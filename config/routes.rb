Ptonfml::Application.routes.draw do
  resources :posts, except: :new

  # SMS
  match 'posts/sms', to: 'posts#sms', via: 'post'

  # Sorting
  match 'liked', to: 'posts#liked', as: :most_liked
  match 'disliked', to: 'posts#disliked', as: :most_disliked

  # Searching
  match 'search', to: 'posts#search', as: :search

  # Comments
  resources :comments, only: [:create, :destroy]

  # Reviewing
  match 'review', to: 'posts#review', as: :review

  match 'posts/:id/approve', to: 'posts#approve', via: 'put', as: :approve_post
  match 'posts/:id/disapprove', to: 'posts#disapprove', via: 'put', as: :disapprove_post

  # Voting
  match 'posts/upvote', to: 'posts#upvote', via: 'post'
  match 'posts/downvote', to: 'posts#downvote', via: 'post'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root to: 'posts#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
