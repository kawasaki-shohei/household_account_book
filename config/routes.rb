Rails.application.routes.draw do

  get 'analyses', to: 'analyses#index'
  resources :fronts #fixme: 削除する

  get 'admin/' , to: 'admin#index', as: :admin
  get 'admin/insert_6_months_expenses' , to: 'admin#insert_6_months_expenses', as: :insert_6_months_expenses_admin
  get 'admin/insert_this_month_expenses' , to: 'admin#insert_this_month_expenses', as: :insert_this_month_expenses_admin
  get 'admin/insert_categories' , to: 'admin#insert_categories', as: :insert_categories_admin
  get 'admin/delete_all_data' , to: 'admin#delete_all_data', as: :delete_all_data_admin

  resources :sessions, only: [:new, :create, :destroy]

  resource :user, except: [:show, :destroy]
  # resources :users, only: [:new, :create, :show, :edit] do
  #   put :register_partner, on: :member
  #   patch :register_partner, on: :member
  #   resources :settings, only: [:index] do
  #     get :change_allow_share_own, on: :collection
  #   end
  # end

  resources :expenses, except: :show

  resources :notifications, only: [:index, :create, :destroy]

  resources :repeat_expenses do
    collection do
      get :both
      post :confirm
    end
  end

  resources :categories do
    get :cancel, on: :collection
  end
  resources :common_categories, only: [:update, :destroy]
  resources :budgets, except: [:show]
  resources :pays, except: [:show]
  resources :deposits, except: [:show]
  get 'deposits/withdraw', to: 'deposits#withdraw', as: :withdraw_deposit

  resources :incomes, except: [:show]
  resources :balances, only: :index

  # resources :wants do
  #   get :change_bought_button, on: :member
  # end

  root to: "analyses#index"
end
