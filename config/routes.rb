Rails.application.routes.draw do
  get 'home/index'

  resources :games, param: :name, shallow: true, only: [:index, :create, :show] do
    resources :players, only: [:index, :create, :show, :new] do
      resources :words, only: [:index, :create, :show, :new]
    end
    resources :rounds, only: [:create]
    resources :turns, only: [:create]
  end

  get '/:name/join', to: "games#join"
  get '/:name/results', to: "games#results", as: :game_results
  post '/join', to: "games#join"

  get '/:name', to: "rounds#play", as: :play_round
  post '/:name/next_turn/:id/', to: "rounds#next_turn", as: :next_turn

  get '/:name/play/', to: "turns#play", as: :play_turn
  post '/:name/next_word/:id/', to: "turns#next_word", as: :next_word
  post '/:name/end_turn/:id/', to: "turns#end", as: :end_turn

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
