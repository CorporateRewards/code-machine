Rails.application.routes.draw do

  get 'code_imports/new'

  devise_for :admins
  get 'code_submissions' => 'sessions#create'

  resources :mr_users
  resources :pages
  resources :code_submissions do
    collection { get :list }
  end
  root "pages#home", page: "home"
  get "pages/home/:usr" => "pages#home"
  put "approve_code" => "codes#approve"
  put "process_code" => "codes#process_code", as: :process_code
  get "approvals" => "codes#approval"
  get "claim/:id" => "codes#user_codes", as: :claims
  get "export_codes" => "codes#export_all_codes"
  get "export_claimed_codes" => "codes#claimed_codes"
  resources :codes do
    collection { post :import }
    collection { post :update_codes }
  end

  resources :promotions
  resources :code_imports
end
