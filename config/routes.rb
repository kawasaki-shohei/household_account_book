Rails.application.routes.draw do

  get 'home/index'
  root to: 'home#index'

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

  resource :preview, only: [:create, :destroy]

  namespace :admin do
    get '/', to: 'sessions#new'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users, only: [:index]
    get 'users', to: 'users#index', as: :top
  end

  resources :fronts #fixme: 削除する

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

  get 'expenses', to: 'expenses#index', as: :mypage_top
end
