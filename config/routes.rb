KickTheTires::Application.routes.draw do
  root to: 'cities#index'
  resources :cities do
    collection do
      get 'search'
      get 'clear_fields'
    end
  end

  match 'cities/viewcity/:id' => 'cities#viewcity', :as => :viewcity
  match 'cities/add_tag/:id' => 'cities#add_tag', :as => :addtag
end
