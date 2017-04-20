Rails.application.routes.draw do
  resources :snippets
  root 'static_pages#home'
end
