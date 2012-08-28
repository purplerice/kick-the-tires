KickTheTires::Application.routes.draw do
  root to: 'cities#index'
  resources :cities
end
