Rails.application.routes.draw do
  get 'home/index'

  resources :games, param: :name, shallow: true, only: [:index, :create, :show] do
    resources :players, only: [:index, :create, :show, :new] do
      resources :words, only: [:index, :create, :show, :new]
    end
    resources :rounds, only: [:create]
    resources :turns, only: [:create]
  end

  get '/:name', to: "games#join"
  post '/join', to: "games#join"

  get '/:name/play/', to: "rounds#play", as: :play_round
  post '/:name/next_turn/:id/', to: "rounds#next_turn", as: :next_turn

  get '/:name/play/turn/', to: "turns#play", as: :play_turn
  post '/:name/next_word/:id/', to: "turns#next_word", as: :next_word

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
