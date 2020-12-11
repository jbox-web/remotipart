Rails.application.routes.draw do
  match 'comments', to: 'comments#create', via: [:put]
  match 'say', to: 'comments#say', via: [:get]
  resources :comments
  root to: 'comments#index'
end
