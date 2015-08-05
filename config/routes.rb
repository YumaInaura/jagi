Rails.application.routes.draw do
  resources :user_profiles, only: [:show, :edit, :update]
end
