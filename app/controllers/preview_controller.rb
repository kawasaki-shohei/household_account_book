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
      categories = create_preview_categories
      categories.each do |category|
        create_preview_budgets(category)
      end
      create_repeat_expenses
      # 毎月入力するもの(出費、収入、貯金、引き出し)
    end
  end

  private

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
    budget = category.budgets.build(user: @user)
    case category.name
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

  def create_repeat_expenses
    category = Category.find_by(name: category_name("living"))
    repeat_expense = RepeatExpense.new(
      user: @user,
      category: category,
      memo: "家賃",
      amount: 90000,
      is_for_both: true,
      percent: :manual_amount,
      mypay: 50000,
      partnerpay: 40000,
      start_date: Date.current.months_ago(3).beginning_of_month,
      end_date: Date.current.months_since(3).end_of_month,
      repeat_day: 10
    )
    repeat_expense.set_new_item_id
    repeat_expense.save!
    Expense.creat_repeat_expenses!(repeat_expense)
  end
end
