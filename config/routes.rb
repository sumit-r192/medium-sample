Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: 'auth', controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions'
      }

      resource :profile, only: [:show, :update], controller: 'profiles'
      resources :posts, except: [:new, :edit] do
        member do
          post 'like'
          delete 'unlike'
        end
        resources :comments, only: [:new, :edit] do
          member do
            post 'like'
            delete 'unlike'
          end
        end
      end
    end
  end
end
