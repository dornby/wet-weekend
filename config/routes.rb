Rails.application.routes.draw do
  get 'welcome/index'

  resources :searches

  root 'welcome#index'
end
