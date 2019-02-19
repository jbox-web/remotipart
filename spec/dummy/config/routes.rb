Rails.application.routes.draw do
  match 'comments', to: 'comments#create', via: [:put]
  resources :comments
  root to: 'comments#index'
end
