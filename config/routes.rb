Rails.application.routes.draw do
    
    devise_for :admins, controllers: {
      sessions:      'admins/sessions',
      passwords:     'admins/passwords',
      registrations: 'admins/registrations'
    }
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations'
    }
    
    root to: 'homes#top'
    
    scope module: :users do
        
        resources :users, only: [:show, :edit, :update] do
            member do
                get :follows, :followers
            end
            resource :relationships, only: [:create, :destroy]
        end

        resources :posts, only: [:index, :show, :create, :update, :destroy] do
            resource :favorites, only: [:create, :destroy]
            resources :comments, only: [:create, :destroy]
        end
        resources :follows, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'
        
        
        resources :reposts, only: [:create, :destroy]
        resources :tags, only: [:create, :destroy]
    end

    devise_scope :user do
        get '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
        post '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    end
    
    namespace :admins do
        resources :admins, only: [:index, :show, :destroy]
    end


    
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
