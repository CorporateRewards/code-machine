Rails.application.routes.draw do

  get 'code_submissions' => 'sessions#create'

  resources :mr_users
  resources :pages
  resources :code_submissions
  root "pages#home", page: "home"
  get "pages/home/:usr" => "pages#home"
  resources :codes

end
