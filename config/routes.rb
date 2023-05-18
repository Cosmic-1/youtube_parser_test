Rails.application.routes.draw do
  root 'youtube#index'
  get '/search', to: 'youtube#search'
end
