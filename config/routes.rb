Rails.application.routes.draw do
  use_doorkeeper
  root to: "questions#index"

  devise_for :users, controllers: {
      omniauth_callbacks: 'omniauth_callbacks',
      registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers, only: [:show, :index, :create]
      end
    end
  end

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      put 'mark_the_best'
    end
    resources :subscriptions, shallow: true, only: [:create, :destroy]
  end



  devise_scope :user do
    patch 'omniauth_callbacks/user_email/:id', to: 'omniauth_callbacks#set_user_email', as: 'set_user_email'
  end

  mount ActionCable.server => '/cable'
end
