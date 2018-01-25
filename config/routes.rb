Rails.application.routes.draw do
  get 'home/index'

  resources :games, param: :name, shallow: true do
    resources :players do
      resources :words
    end
  end

  get '/:name', to: "games#show"


  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
