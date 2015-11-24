Rails.application.routes.draw do
  root 'emails#classify'
  resources :domains, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :goals
  resources :users, only: [:index, :new, :create, :edit, :update, :show]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :emails, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :clusters
  post 'emails/import'
  get 'domains/parked'
  get 'emails/upload'
  get 'emails/classify'
  post 'emails/edit'
  get 'emails/total'
  get 'emails/total2013'
  get 'emails/total2015'
  get 'emails/total2016'
  get 'emails/total2017'
  get 'emails/total2018'
  get 'emails/annual'
  get 'emails/metrics'
  get 'emails/summary'
  get 'emails/intensity'
  get 'emails/intensity2013'
  get 'emails/intensity2015'
  get 'emails/intensity2016'
  get 'emails/intensity2017'
  get 'emails/intensity2018'
  get 'emails/volume'
  get 'emails/volume2013'
  get 'emails/volume2015'
  get 'emails/volume2016'
  get 'emails/volume2017'
  get 'emails/volume2018'
  get 'emails/diversity'
  get 'emails/diversity2013'
  get 'emails/diversity2015'
  get 'emails/diversity2016'
  get 'emails/diversity2017'
  get 'emails/diversity2018'
  get 'emails/intensity_achieved'
  get 'emails/intensity_achieved2013'
  get 'emails/intensity_achieved2015'
  get 'emails/intensity_achieved2016'
  get 'emails/intensity_achieved2017'
  get 'emails/intensity_achieved2018'
  post 'emails/analytics'
  #post 'domains' => 'emails#edit'


  #route for import from CSV.

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
