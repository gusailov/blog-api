Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :articles, shallow: true do
    resources :comments
  end

  resources :categories

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[show]
      resources :categories

      scope module: :users do
        resources :users, only: %i[] do
          resources :articles, only: %i[index]
        end
      end

      scope module: :categories do
        resources :categories, only: %i[] do
          resources :articles, only: %i[index]
        end
      end

      resources :articles do
        resources :comments
      end
    end
  end
end
