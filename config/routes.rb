Rails.application.routes.draw do

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
  resources :badgets
  resources :pays
  resources :wants do
    get :change_bought_button, on: :member
  end

  resources :deposits, except: [:show]
  get 'deposits/withdraw', to: 'deposits#withdraw', as: :withdraw_deposit

  # get 'bought_buttons/bought/:id', to: 'bought_buttons#bought', as: :bought
  # get 'bought_buttons/want/:id', to: 'bought_buttons#want', as: :back_to_want

  root to: "expenses#index"
end
