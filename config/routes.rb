Rails.application.routes.draw do

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
  resources :codes do
    collection { post :import }
  end

  # get "import" => "codes#import"
  # post "import" => "codes#import"

end
