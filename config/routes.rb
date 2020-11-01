Rails.application.routes.draw do
  get 'courses/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/callback' => 'webhook#callback'
  get '/' => 'courses#index'
  #get '/' => 'users#unauthorized'

  get '/users/:line_id/sign_in' => 'users#sign_in'
  get '/users/:line_id/sign_up' => 'users#sign_up'

  resources :users, only:[:index, :edit, :update] do
    resources :courses, only:[:index, :edit, :show, :update]
    resources :course_times, only:[:index, :edit, :show, :update]
  end
end
