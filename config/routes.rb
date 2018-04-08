Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]

  resources :users
  resources :partners, only:[:new, :create, :destroy]

  resources :expenses do
    collection do
      get :both
      post :confirm
    end
  end
  get 'shift_months/past/:id', to: 'shift_months#past', as: :past_expense
  get 'shift_months/future/:id', to: 'shift_months#future', as: :future_expense

  resources :categories do
    collection do
      get :common
    end
  end
  resources :badgets
  resources :pays

  root to: "expenses#both"
end
