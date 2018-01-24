Rails.application.routes.draw do
  get 'home/index'

  resources :games, param: :name do
    resources :players do
      resources :words
    end
  end

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
