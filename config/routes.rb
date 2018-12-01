Rails.application.routes.draw do
  get 'welcome/index'

  resources :search

  root 'welcome#index'
end
