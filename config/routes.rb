Rails.application.routes.draw do
  mount ActionCable.server => '/subscriptions'

  post 'sign_in' => 'user_token#create'
  resources :sign_up

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]
      resources :conversations do
        resources :messages, only: [:index, :show, :create]
      end
    end
  end
end
