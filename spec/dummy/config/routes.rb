# frozen_string_literal: true

Rails.application.routes.draw do
  match 'comments', to: 'comments#create', via: [:put]
  match 'say', to: 'comments#say', via: [:get]
  resources :comments
  match 'prepended', to: 'prepended#show', via: [:get]
  root to: 'comments#index'
end
