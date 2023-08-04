Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: 'auth', controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions'
      }

      post 'auth/login', to: 'authentication#login'
      delete 'auth/logout', to: 'authentication#logout'
      get 'search', to: 'posts#search'

      resource :profile, only: [:show, :update], controller: 'profiles'
      resources :posts, except: [:new, :edit] do
        member do
          post 'like'
          delete 'unlike'
          post 'save_for_later'
          delete 'unsave'
          get 'more_posts_by_similar_author'
        end

        collection do
          get 'author_posts'
          get 'top_posts'
          get 'recommended_posts'
        end

        resources :comments, only: [:create]
      end

      resources :comments, except: [:new, :edit, :create] do
        member do
          post 'like'
          delete 'unlike'
        end
      end

      resources :users, only: [:show] do
        member do
          post 'follow'
          delete 'unfollow'
        end
      end
    end
  end
end
