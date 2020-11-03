Rails.application.routes.draw do
  get 'courses/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/callback' => 'webhook#callback'
  get '/' => 'courses#index'
  #get '/' => 'users#unauthorized'

  get '/users/:line_id/:reply_token/sign_in' => 'users#sign_in' #need to include reply_token
  get '/users/:line_id/:reply_token/sign_up' => 'users#sign_up'


  resources :users, only:[:index, :edit, :update, :create] do
    resources :courses, only:[:index, :edit, :show, :update]
    resources :course_times, only:[:index, :edit, :show, :update]
  end
end
