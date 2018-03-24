Rails.application.routes.draw do
  get 'pays/index'

  get 'pays/new'

  get 'pays/edit'

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
  resources :pays

  root to: "expenses#both"
end
