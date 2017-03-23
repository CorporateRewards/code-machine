Rails.application.routes.draw do

  get 'code_submissions' => 'sessions#create'

  resources :mr_users
  resources :pages
  resources :code_submissions
  root "pages#home", page: "home"
  get "pages/home/:usr" => "pages#home"
  resources :codes do
    collection { post :import }
  end

  # get "import" => "codes#import"
  # post "import" => "codes#import"

end
