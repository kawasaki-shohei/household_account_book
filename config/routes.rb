Rails.application.routes.draw do

  get 'home/index'
  root to: 'home#index'

  namespace :admin do
    get '/', to: 'sessions#new'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users, only: [:index]
  end

  resources :fronts #fixme: 削除する

  resource :user, except: [:new, :create, :show, :destroy]
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  # resources :users, only: [:new, :create, :show, :edit] do
  #   resources :settings, only: [:index] do
  #     get :change_allow_share_own, on: :collection
  #   end
  # end
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :notifications, only: [:index, :update] do
    patch :bulk_update, on: :collection
  end

  resource :partner_mode, only: [:create, :destroy]

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
  resources :expenses, except: :show
  resources :repeat_expenses do
    collection do
      get :both
      post :confirm
    end
  end

  get 'analyses', to: 'analyses#index'

  # get 'admin/' , to: 'admin#index', as: :admin
  # get 'admin/insert_6_months_expenses' , to: 'admin#insert_6_months_expenses', as: :insert_6_months_expenses_admin
  # get 'admin/insert_this_month_expenses' , to: 'admin#insert_this_month_expenses', as: :insert_this_month_expenses_admin
  # get 'admin/insert_categories' , to: 'admin#insert_categories', as: :insert_categories_admin
  # get 'admin/delete_all_data' , to: 'admin#delete_all_data', as: :delete_all_data_admin
end
