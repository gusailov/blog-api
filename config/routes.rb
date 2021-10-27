Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :articles, shallow: true do
    resources :comments
  end

  namespace :api do
    namespace :v1 do
      resources :articles, shallow: true do
        resources :comments
      end
    end
  end
end
