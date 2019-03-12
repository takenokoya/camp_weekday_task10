Rails.application.routes.draw do
  get 'areas/search' => 'areas#search'
  resources :areas, :only => [ :index, :show, :new, :create ]
  root 'areas#search'
end
