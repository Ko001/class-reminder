Rails.application.routes.draw do
  get 'courses/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/callback' => 'webhook#callback'
  get '/' => 'courses#index'
  resources :courses, only:[:index, :edit, :show, :update]
end
