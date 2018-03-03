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
  end
  resources :categories
  resources :badgets
  root to: "expenses#both"
end
