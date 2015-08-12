Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :page, only: [:index, :show, :new, :create, :edit, :update]
  resources :user_profiles, only: [:index, :show, :new, :create, :edit, :update]
  root to: "page#index"
end
