Rails.application.routes.draw do
  mount ActionCable.server => '/subscriptions'

  post 'sign_in' => 'user_token#create'
  resources :sign_up

  namespace :api do
    namespace :v1 do
      get 'users/search/:search_text', to: 'users#search'
      resources :users, only: [:index, :show]
      resources :conversations do
        resources :messages, only: [:index, :show, :create]
      end
    end
  end
end
