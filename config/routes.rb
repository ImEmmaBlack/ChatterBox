Rails.application.routes.draw do
  mount ActionCable.server => '/subscriptions'

  post 'sign_in' => 'user_token#create'
  resources :sign_up

  namespace :api do
    namespace :v0 do
      get 'messages/:user_id', to: 'messages#index'
      post 'messages/:user_id', to: 'messages#create'
    end
    namespace :v1 do
      resources :users, only: [:index]
      resources :conversations, only: [:index, :show, :create, :update] do
        resources :messages, only: [:index, :show, :create]
      end
    end
  end
end
