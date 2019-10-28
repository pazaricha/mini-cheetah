Rails.application.routes.draw do
  resources :products, only: [:index, :show]
  resources :shopping_lists, only: :show do
    resources :shopping_list_items, only: [:create, :destroy] do
      member do
        patch :reposition
      end
    end
  end
end
