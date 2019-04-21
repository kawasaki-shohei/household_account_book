Rails.application.routes.draw do

  get 'admin/' , to: 'admin#index', as: :admin
  get 'admin/insert_6_months_expenses' , to: 'admin#insert_6_months_expenses', as: :insert_6_months_expenses_admin
  get 'admin/insert_this_month_expenses' , to: 'admin#insert_this_month_expenses', as: :insert_this_month_expenses_admin
  get 'admin/insert_categories' , to: 'admin#insert_categories', as: :insert_categories_admin
  get 'admin/delete_all_data' , to: 'admin#delete_all_data', as: :delete_all_data_admin

  resources :sessions, only: [:new, :create, :destroy]

  resources :users do
    put :register_partner, on: :member
    patch :register_partner, on: :member
    resources :settings, only: [:index] do
      get :change_allow_share_own, on: :collection
    end
  end

  resources :expenses do
    collection do
      get :both
      post :confirm
    end
  end

  resources :notifications, only: [:index, :create, :destroy]

  get 'category_expenses/:category_id/:cnum', to: 'expenses#each_category', as: :each_category_expense

  get 'shift_months/past/:id', to: 'shift_months#past', as: :past_expense
  get 'shift_months/future/:id', to: 'shift_months#future', as: :future_expense

  resources :repeat_expenses do
    collection do
      get :both
      post :confirm
    end
  end

  resources :categories do
    collection do
      get :common
    end
  end
  resources :budgets
  resources :pays
  resources :wants do
    get :change_bought_button, on: :member
  end

  resources :deposits, except: [:show]
  get 'deposits/withdraw', to: 'deposits#withdraw', as: :withdraw_deposit

  resources :incomes
  resources :balances, only: :index

  # get 'bought_buttons/bought/:id', to: 'bought_buttons#bought', as: :bought
  # get 'bought_buttons/want/:id', to: 'bought_buttons#want', as: :back_to_want

  root to: "expenses#index"
end
