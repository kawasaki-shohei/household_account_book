Rails.application.routes.draw do
  get 'partners/new'

  resources :sessions, only: [:new, :create, :destroy]

  resources :users
  resources :partners, only:[:new, :create, :destroy]

  resources :expenses do
    collection do
      get :both
      post :confirm
    end
    member do
      get :past
      get :future
    end
  end
  resources :categories do
    collection do
      get :common
    end
  end
  resources :badgets
  root to: "expenses#both"
end
