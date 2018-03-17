Rails.application.routes.draw do

  devise_for :admins
  get 'code_submissions' => 'sessions#create'

  resources :mr_users
  resources :pages
  resources :code_submissions do
    collection { get :list }
  end
  root "pages#home", page: "home"
  get "pages/home/:usr" => "pages#home"
  get "approve_code" => "codes#approve"
  get "approvals" => "codes#approval"
  get "claim/:id" => "codes#user_codes", as: :claims
  resources :codes do
    collection { post :import }
  end

  # get "import" => "codes#import"
  # post "import" => "codes#import"

end
