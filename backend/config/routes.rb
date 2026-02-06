Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create]
  resources :patients
  resources :claims
  resources :claim_imports, only: [:index, :show, :create] do
    post :import, on: :collection

  end

  get "up" => "rails/health#show", as: :rails_health_check

end
