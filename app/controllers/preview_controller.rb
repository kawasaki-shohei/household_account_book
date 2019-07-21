class PreviewController < ApplicationController
  skip_before_action :check_logging_in
  skip_before_action :check_partner
  skip_before_action :count_header_notifications, raise: false
  skip_before_action :check_access_right, raise: false

  def create
    # カテゴリー、予算、出費、繰り返し出費、精算、収入、貯金、引き出し、通知(出費3件、精算1件)
    ActiveRecord::Base.transaction do
      @user = create_preview_user
      @partner = create_preview_partner
      @categories = create_preview_categories
      @categories.each do |category|
        define_category_instance_variables(category)
        create_preview_budgets(category)
      end

      # 毎月入力するもの(出費、収入、貯金、引き出し)
      three_months_period = [
        Date.current.months_ago(2).to_s_as_period,
        Date.current.last_month.to_s_as_period,
        Date.current.to_s_as_period
      ]
      three_months_period.each do |period|
        create_preview_expenses(period)
        create_preview_incomes(period)
        create_preview_deposits(period)
      end
      create_preview_withdraw
      create_preview_repeat_expenses
    end
  end

  private

  def define_category_instance_variables(category)
    names_hash = t('category_master.name')
    key = names_hash.key(category.name)
    eval "@#{key}=category"
  end

  def create_preview_user
    User.create!(
      name: "プレビュー",
      email: "test-user@pairmoney.com",
      password: Rails.application.credentials.preview_user_password,
      allow_share_own: true,
      is_preview_user: true
    )
  end

  def create_preview_partner
    partner = User.create!(
      name: "パートナー",
      email: "test-partner@pairmoney.com",
      password: Rails.application.credentials.preview_user_password,
      allow_share_own: true,
      is_preview_user: true
    )
    Couple.create!(user: @user, partner: partner)
    Couple.create!(user: partner, partner: @user)
    partner
  end

  def create_preview_categories
    categories = []
    CategoryMaster.all.each do |category_master|
      categories << category_master.categories.create!(category_master.attributes_without_id_and_timestamps.merge(user_id: @user.id))
    end
    categories
  end

  def category_name(name)
    t("category_master.name.#{name}")
  end

  def create_preview_budgets(category)
    # 合計18,0000円 + 定額貯金50,000円
    budget = category.budgets.build(user: @user)
    case category.name
    # 共通のカテゴリー
    when category_name("food")
      budget.amount = 50000
    when category_name("convenience_goods")
      budget.amount = 5000
    when category_name("data")
      budget.amount = 12000
    when category_name("utility")
      budget.amount = 10000
    when category_name("living")
      budget.amount = 50000
    when category_name("entertainment")
      budget.amount = 10000
    # 自分だけのカテゴリー
    when category_name("transportation")
      budget.amount = 10000
    when category_name("entertainment_expense")
      budget.amount = 8000
    when category_name("learning")
      budget.amount = 12000
    when category_name("medical")
      budget.amount = 5000
    when category_name("beauty")
      budget.amount = 8000
    end
    # amountを入力しないものは予算を設定しない
    budget.save! if budget.amount
  end

  def save_repeat_expense!(repeat_expense)
    repeat_expense.set_new_item_id
    repeat_expense.save!
    Expense.creat_repeat_expenses!(repeat_expense)
  end

  def create_preview_repeat_expenses
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

  def create_preview_incomes(period)
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

  def create_preview_deposits(period)
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

  def create_preview_withdraw
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

  def create_preview_expenses(period)
    first_day = period.to_beginning_of_month
    end_day = period.to_end_of_month
    # { manual_amount: -1, pay_all: 0, pay_half: 1, pay_one_third: 2, pay_two_thirds: 3, pay_nothing: 4 }

    # 毎日
    (first_day..end_day).each do |date|
      # 二人の食費 毎日 500 ~ 3,000
      own_both_expense = both_expense_instance(@user, @food, date)
      own_both_expense.assign_attributes(
        amount: rand(500..3000),
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

end
