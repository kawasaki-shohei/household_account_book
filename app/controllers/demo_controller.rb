class DemoController < ApplicationController
  protect_from_forgery
  skip_before_action :check_logging_in
  skip_before_action :check_partner
  skip_before_action :count_header_notifications, raise: false
  skip_before_action :check_access_right, raise: false

  def create
    notifier = SlackNotifier.new(request, session)
    notifier.notify_starting_demo

    # プレビューモードが2回目の場合
    if current_user.present? && session[:demo_user_id]
      redirect_to mypage_top_path and return
    end

    create_demo_records
    if session[:demo_user_id]
      notifier.notify_succeeded_demo
      redirect_to mypage_top_path
    else
      notifier.notify_failed_demo
      redirect_to root_path, alert: "プレビューが失敗しました。"
    end
  end

  def destroy
    unless demo_users = collect_demo_users
      head 200
    end
    # 注意 Expense Income RepeatExpense Category Couple
    normal_tables = %w(budgets balances pays deposits notifications)

    demo_users.each do |user|
      ActiveRecord::Base.transaction do
        partner = user.partner
        # 出費テーブル
        user.expenses.each do |expense|
          expense.skip_calculate_balance = true
          expense.destroy
        end
        partner.expenses.each do |expense|
          expense.skip_calculate_balance = true
          expense.destroy
        end
        ActiveRecord::Base.connection.reset_pk_sequence!("expenses")
        # 収入テーブル
        user.incomes.each do |income|
          income.skip_calculate_balance = true
          income.destroy
        end
        partner.incomes.each do |income|
          income.skip_calculate_balance = true
          income.destroy
        end
        ActiveRecord::Base.connection.reset_pk_sequence!("incomes")

        normal_tables.each do |table|
          user.send(table).each(&:destroy)
        end
        normal_tables.each do |table|
          partner.send(table).each(&:destroy)
          ActiveRecord::Base.connection.reset_pk_sequence!(table)
        end
        # 繰り返し出費テーブル
        user.repeat_expenses.with_deleted&.each(&:really_destroy!)
        partner.repeat_expenses.with_deleted&.each(&:really_destroy!)
        ActiveRecord::Base.connection.reset_pk_sequence!("repeat_expenses")
        # カテゴリーテーブル
        user.categories.each(&:destroy)
        partner.categories.each(&:destroy)
        ActiveRecord::Base.connection.reset_pk_sequence!("categories")
        # カップルテーブル
        Couple.find_by(user: user).destroy
        Couple.find_by(user: user.partner).destroy
        ActiveRecord::Base.connection.reset_pk_sequence!("couples")
        user.destroy
        partner.destroy
        ActiveRecord::Base.connection.reset_pk_sequence!("users")
      end
    end

    if User.where(is_demo_user: true).blank?
      render plain: "succeeded", status: 200
    else
      render plain: "failed", status: 200
    end
  end

  private

  def create_demo_records
    # カテゴリー、予算、出費、繰り返し出費、精算、収入、貯金、引き出し、通知(出費3件、精算1件)
    ActiveRecord::Base.transaction do
      @user = create_demo_user
      @partner = create_demo_partner
      @categories = create_demo_categories
      @categories.each do |category|
        define_category_instance_variables(category)
        create_demo_budgets(category)
      end

      # 1回だけ入力するもの
      create_demo_withdraw
      create_demo_repeat_expenses

      # 毎月入力するもの(出費、収入、貯金、引き出し)
      three_months_period = [
        Date.current.months_ago(2).to_s_as_period,
        Date.current.last_month.to_s_as_period,
        Date.current.to_s_as_period
      ]
      three_months_period.each do |period|
        create_demo_expenses(period)
        create_demo_incomes(period)  # balanceを計算するためexpensesよりも後にする。
        create_demo_deposits(period)
        create_demo_pays(period)
      end

      # ログイン
      session[:demo_user_id] = @user.id
    end
  rescue => e
    # todo: slack通知する
    logger.error(e)
  end

  def define_category_instance_variables(category)
    names_hash = t('category_master.name')
    key = names_hash.key(category.name)
    eval "@#{key}=category"
  end

  def create_demo_user
    User.create!(
      name: "プレビュー",
      email: Faker::Internet.safe_email,
      password: Rails.application.credentials.demo_user_password,
      allow_share_own: true,
      is_demo_user: true
    )
  end

  def create_demo_partner
    partner = User.create!(
      name: "パートナー",
      email: Faker::Internet.safe_email,
      password: Rails.application.credentials.demo_user_password,
      allow_share_own: true,
      is_demo_user: true
    )
    Couple.create!(user: @user, partner: partner)
    Couple.create!(user: partner, partner: @user)
    partner
  end

  def create_copied_category(user, category_masters)
    categories = []
    category_masters.each do |category_master|
      categories << category_master.categories.create!(category_master.attributes_without_id_and_timestamps.merge(user_id: user.id))
    end
    categories
  end

  def create_demo_categories
    categories = []
    own_category_masters = CategoryMaster.where(is_common: false).order(:id)
    own_common_category_masters, partner_common_category_masters = CategoryMaster.where(is_common: true).partition { |category_master| category_master.id.even? }
    # 自分だけのカテゴリーを登録
    categories += create_copied_category(@user, own_category_masters)
    categories += create_copied_category(@partner, own_category_masters)
    # 共通のカテゴリーを登録
    categories += create_copied_category(@user, own_common_category_masters)
    categories += create_copied_category(@partner, partner_common_category_masters)
    categories
  end

  def category_name(name)
    t("category_master.name.#{name}")
  end

  def create_demo_budgets(category)
    # 合計18,0000円 + 定額貯金50,000円
    own_budget = category.budgets.build(user: @user)
    partner_budget = category.budgets.build(user: @partner)
    case category.name
    # 共通のカテゴリー
    when category_name("food")
      own_budget.amount = 50000
      partner_budget.amount = 60000
    when category_name("convenience_goods")
      own_budget.amount = 5000
      partner_budget.amount = 6000
    when category_name("data")
      own_budget.amount = 12000
      partner_budget.amount = 14000
    when category_name("utility")
      own_budget.amount = 10000
      partner_budget.amount = 12000
    when category_name("living")
      own_budget.amount = 50000
      partner_budget.amount = 50000
    when category_name("entertainment")
      own_budget.amount = 10000
      partner_budget.amount = 10000
    # 自分だけのカテゴリー
    when category_name("transportation")
      own_budget.amount = 10000
      partner_budget.amount = 12000
    when category_name("entertainment_expense")
      own_budget.amount = 8000
      partner_budget.amount = 10000
    when category_name("learning")
      own_budget.amount = 12000
      partner_budget.amount = 14000
    when category_name("medical")
      own_budget.amount = 5000
      partner_budget.amount = 5000
    when category_name("beauty")
      own_budget.amount = 8000
      partner_budget.amount = 4000
    end
    # amountを入力しないものは予算を設定しない
    own_budget.save! if own_budget.amount
    partner_budget.save! if partner_budget.amount
  end

  def create_demo_incomes(period)
    @user.incomes.create!(
      amount: 250000,
      date: Date.parse(period + "-25"),
      memo: "お給料"
    )

    @partner.incomes.create!(
      amount: 400000,
      date: Date.parse(period + "-25"),
      memo: "お給料"
    )
  end

  def create_demo_deposits(period)
    @user.deposits.create!(
      amount: 30000,
      date: Date.parse(period + "-26"),
      memo: "定額貯金"
    )

    @partner.deposits.create!(
      amount: 50000,
      date: Date.parse(period + "-26"),
      memo: "定額貯金"
    )
  end

  def create_demo_withdraw
    @user.deposits.create!(
      amount: 10000,
      date: Date.current,
      is_withdrawn: true,
      memo: "緊急出費"
    )
  end

  def random_date(period)
    Date.parse("#{period}-#{rand(1..27)}")
  end

  def new_expense_instance(user, category, date)
    Expense.new(
      user: user,
      category: category,
      date: date,
      skip_calculate_balance: true
    )
  end

  def own_expense_instance(user, category, date)
    expense = new_expense_instance(user, category, date)
    expense.assign_attributes(is_for_both: false)
    expense
  end

  def both_expense_instance(user, category, date)
    expense = new_expense_instance(user, category, date)
    expense.assign_attributes(is_for_both: true)
    expense
  end

  def create_demo_expenses(period)
    first_day = period.to_beginning_of_month
    end_day = period.to_end_of_month

    # 毎日
    (first_day..end_day).step(2).each do |date|
      # 二人の食費 2日に1回 500 ~ 3,000
      own_both_expense = both_expense_instance(@user, @food, date)
      own_both_expense.assign_attributes(
        amount: rand(1000..4000),
        percent: :pay_one_third,
      )
      own_both_expense.save!

      # 自分の食費 毎日 120 ~ 300
      own_expense = own_expense_instance(@user, @food, date)
      own_expense.assign_attributes(amount: rand(120..300))
      own_expense.save!

      # パートナー自分の食費 毎日 120 ~ 300
      partner_expense = own_expense_instance(@partner, @food, date)
      partner_expense.assign_attributes(amount: rand(120..300))
      partner_expense.save!

      # 週１回
      if date.wday == 6 # 土曜日
        # [convenience_goods] 日用品 毎週土曜日 1000 ~ 2000 半分
        partner_both_expense = both_expense_instance(@partner, @convenience_goods, date)
        partner_both_expense.assign_attributes(
          amount: rand(1000..2000),
          percent: :pay_half,
        )
        partner_both_expense.save!
      end

      if date.wday == 0 # 日曜日
        # [entertainment] エンタメ 毎週日曜日 200 ~ 3000 3分の2
        partner_both_expense = both_expense_instance(@partner, @convenience_goods, date)
        partner_both_expense.assign_attributes(
          amount: rand(200..3000),
          percent: :pay_two_thirds,
        )
        partner_both_expense.save!
      end
    end

    # 月一回
    # [utility] 水道代 1400 ~ 1900 パートナー
    water_date = Date.parse(period + '-19')
    partner_both_expense = both_expense_instance(@partner, @utility, water_date)
    partner_both_expense.assign_attributes(
      amount: rand(1400..1900),
      percent: :pay_half,
      memo: "水道代"
    )
    partner_both_expense.save!

    # [utility] 電気代 2600 ~ 3000 パートナー
    electricity_date = Date.parse(period + '-18')
    partner_both_expense = both_expense_instance(@partner, @utility, electricity_date)
    partner_both_expense.assign_attributes(
      amount: rand(2600..3000),
      percent: :pay_half,
      memo: "電気代"
    )
    partner_both_expense.save!

    # [utility] ガス代 2000 ~ 2500 パートナー
    gas_date = Date.parse(period + '-03')
    partner_both_expense = both_expense_instance(@partner, @utility, gas_date)
    partner_both_expense.assign_attributes(
      amount: rand(2000..2500),
      percent: :pay_half,
      memo: "ガス代"
    )
    partner_both_expense.save!

    [@user, @partner].each do |person|
      # [data] 通信 携帯代 10000 ~ 12000
      data_date = period.to_end_of_month
      own_expense = own_expense_instance(person, @data, data_date)
      own_expense.assign_attributes(amount: rand(10000..12000))
      own_expense.save!

      # [beauty] 美容 8000
      beauty_date = Date.parse(period + '-27')
      own_expense = own_expense_instance(person, @data, beauty_date)
      own_expense.assign_attributes(amount: 6000, memo: "美容院")
      own_expense.save!

      # [transportation] 交通費 8000 ~ 10000
      transportation_date = Date.parse(period + '-27')
      own_expense = own_expense_instance(person, @data, transportation_date)
      own_expense.assign_attributes(amount: rand(8000..10000))
      own_expense.save!

      # [entertainment_expense] 交際費 飲み会 4000 ~ 6000
      entertainment_expense_date = random_date(period)
      own_expense = own_expense_instance(person, @data, entertainment_expense_date)
      own_expense.assign_attributes(amount: rand(4000..6000))
      own_expense.save!

      # [learning] 教養 本 1200 ~ 4000
      learning_date = random_date(period)
      own_expense = own_expense_instance(person, @data, learning_date)
      own_expense.assign_attributes(amount: rand(1200..4000))
      own_expense.save!

      # [medical] 病院 or 薬 1000 ~ 5000
      medical_date = random_date(period)
      own_expense = own_expense_instance(person, @data, medical_date)
      own_expense.assign_attributes(amount: rand(1200..4000))
      own_expense.save!

      # [others] その他 3000 ~ 10000
      others_date = random_date(period)
      own_both_expense = both_expense_instance(person, @others, others_date)
      own_both_expense.assign_attributes(
        amount: rand(3000..10000),
        percent: :pay_nothing,
        )
      own_both_expense.save!
    end
  end

  def save_repeat_expense!(repeat_expense)
    repeat_expense.set_new_item_id
    repeat_expense.save!
    Expense.creat_repeat_expenses!(repeat_expense)
  end

  def create_demo_repeat_expenses
    rent = RepeatExpense.new(
      user: @partner,
      category: @living,
      memo: "家賃",
      amount: 90000,
      is_for_both: true,
      percent: :manual_amount,
      mypay: 50000,
      partnerpay: 40000,
      start_date: Date.current.months_ago(2).beginning_of_month,
      end_date: Date.current.months_since(2).end_of_month,
      repeat_day: 10
    )
    save_repeat_expense!(rent)

    english = RepeatExpense.new(
      user: @user,
      category: @learning,
      memo: "英会話",
      amount: 8000,
      is_for_both: false,
      start_date: Date.current.months_ago(2).beginning_of_month,
      end_date: Date.current.months_since(2).end_of_month,
      repeat_day: 27
    )
    save_repeat_expense!(english)
  end

  def create_demo_pays(period)
    # 今月以外は精算する
    return if period == Date.current.to_s_as_period
    pays = Pay.get_couple_pays(@user, @partner)
    expenses = Expense.both_expenses_until_one_month(@user, @partner, period)
    n_month_ago = (Date.current.year * 12 + Date.current.month) - (period.year_number * 12 + period.month_number)
    pay_user = @user  # payを入力する人
    service = CalculateRolloverService.new(@user, @partner, pays, expenses, n_month_ago: n_month_ago)
    rollover = service.call
    if rollover.negative?
      service = CalculateRolloverService.new(@partner, @user, pays, expenses, n_month_ago: n_month_ago)
      rollover = service.call
      pay_user = @partner
    end
    # 精算金額が1000円以上なら四捨五入して支払う
    if rollover >= 1000
      amount = rollover.truncate(-3)
      date = period.to_beginning_of_month.next_month
      Pay.create!(
        amount: amount,
        user: pay_user,
        date: date,
        memo: "#{period.month_string}月分"
      )
    end
  end

  def collect_demo_users
    all_demo_users = User.where(is_demo_user: true)
    target_users = []
    all_demo_users.each do |user|
      unless target_users.include?(user.partner)
        target_users << user
      end
    end
    target_users
  end

end
