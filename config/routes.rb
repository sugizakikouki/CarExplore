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
    
    devise_scope :user do
        get '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
        post '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    end
    
    root 'homes#top'
    
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
        get 'reposts' => 'posts#repost_create'
        get "search" => "posts#search"
        
        resources :follows, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'
        
        
        resources :reposts, only: [:create, :destroy]
        resources :tags, only: [:create, :destroy]
        resources :notifications, only: [:index, :destroy]
    end

    
    namespace :admins do
        root to: 'admins/admins#index'
        resources :admins, only: [:index, :show, :destroy]
    end


    
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
