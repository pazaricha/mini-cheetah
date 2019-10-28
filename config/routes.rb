Rails.application.routes.draw do
  resources :products, only: [:index, :show]
  resources :shopping_lists, only: :show
end
