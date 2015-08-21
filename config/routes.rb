Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :ranking, only: [:index]
  resources :user_profiles, only: [:edit, :update]
  resource :page, only: [:index]
  resource :quiz, only: [:show] do
    member do
      post :answer
    end
  end
  root to: "page#index"
end
