Rails.application.routes.draw do
  resources :shortener, only: [] do
    collection do
      get :encode
      get :decode
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
