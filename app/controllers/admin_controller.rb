class AdminController < ApplicationController
  before_action :check_sys_admin
  def index

  end

  def insert_6_months_expenses

    redirect_to admin_path
  end

  def insert_this_month_expenses
    if current_user.categories.blank? && partner.categories.blank?
      flash[:error] = "カテゴリが一つもないため出費データを作成できません。"
      redirect_to admin_path and return
    end
    Expense.transaction do
      current_user.insert_expenses_for_a_month
      partner.insert_expenses_for_a_month
    end
    flash[:success] = "今月の出費のサンプルデータを作成できました。"
    redirect_to admin_path
    rescue
    flash[:error] = "サンプルデータの作成に失敗しました。"
    redirect_to admin_path
  end

  def insert_categories
    if current_user.categories.any? && partner.categories.any?
      flash[:error] = "カテゴリの挿入に失敗しました。"
    else
      if current_user.insert_categories
        flash[:success] = "サンプルカテゴリを挿入しました。"
      else
        flash[:error] = "カテゴリの挿入に失敗しました。"
      end
    end
    redirect_to admin_path
  end

  def delete_all_data
    current_user.notifications.try(:destroy_all)
    current_user.budgets.try(:destroy_all)
    current_user.wants.try(:destroy_all)
    current_user.pays.try(:destroy_all)
    current_user.deposits.try(:destroy_all)
    current_user.expenses.try(:destroy_all)
    partner.expenses.try(:destroy_all)
    current_user.repeat_expenses.try(:destroy_all)
    partner.repeat_expenses.try(:destroy_all)
    current_user.categories.try(:destroy_all)
    partner.categories.try(:destroy_all)
    flash[:success] = "全て削除しました。"
    redirect_to admin_path
  end

  private
  def check_sys_admin
    unless current_user.sys_admin
      redirect_to root_path
    end
  end
end
