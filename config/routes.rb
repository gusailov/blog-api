Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      resources :categories

      scope module: :users do
        resources :users, only: [] do
          resources :articles, only: %i[index]
        end
      end

      scope module: :categories do
        resources :categories, only: [] do
          resources :articles, only: %i[index]
        end
      end

      resources :articles do
        resources :comments
      end
    end
  end
end
