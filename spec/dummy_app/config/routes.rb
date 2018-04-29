DummyApp::Application.routes.draw do
  match 'comments' => 'comments#create', :via => [:put]
  resources :comments
  root :to => "comments#index"
end
