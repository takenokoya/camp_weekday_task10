Rails.application.routes.draw do
  get 'areas/search' => 'areas#search'
  post 'areas/search' => 'areas#create'
  root 'areas#index'
end
