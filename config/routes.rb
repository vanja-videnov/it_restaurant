Rails.application.routes.draw do
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'require_manager' => 'manager#require_manager'

  get 'manager_reports_daily' => 'manager/reports#daily'
  get 'manager_reports_items' => 'manager/reports#items'
  get 'manager_reports_tables' => 'manager/reports#tables'
  get 'manager_reports_categories' => 'manager/reports#categories'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'sessions#new'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :users, only:[:index, :show, :edit, :update] do
    resources :orders, only:[:index]
  end
  resources :tables, only:[:index, :show, :update, :new, :create, :destroy] do
    resources :orders, only:[:show, :new] do
      resources :order_menu_items, only:[ :create, :destroy]
    end
  end
  resources :menus, only:[:index, :show]
  # resources :items, only:[:index, :show]

  resources :manager, only: [:index]
  namespace :manager do
    resources :reports, only:[:show, :index]
    resources :users, only:[:new, :create, :destroy]
    resources :categories, only:[:new, :create, :show, :edit, :update, :destroy] do
      resources :subcategories, only:[:new, :create, :edit, :update, :destroy]
    end
    resources :menus , only:[:new, :create, :edit, :update, :destroy] do
      resources :items, only:[:new, :create, :edit, :update, :destroy]
    end
  end
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
