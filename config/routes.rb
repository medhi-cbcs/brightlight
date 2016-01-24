Rails.application.routes.draw do

  resources :copy_conditions, except: [:index]
  resources :book_labels
  resources :rosters
  resources :departments
  resources :guardians
  resources :book_assignments
  resources :book_grades
  resources :students
  resources :employees
  resources :products
  resources :academic_years
  resources :rosters
  resources :courses do
    resources :course_texts, shallow: true
    resources :course_sections, except: :new, shallow: true
  end

  resources :book_editions do
    collection do
      post 'search_isbn'
    end
    resources :book_copies, shallow: true
    member do
      get 'new_labels'
    end
  end

  get 'book_copies/:id/conditions' => 'copy_conditions#index', as: :book_copy_conditions

  resources :book_titles do
    collection do
      post 'edit_merge' # edit merges
      post 'merge'      # merges several book titles together
      post 'delete'     # deletes several book titles at the same time
      post 'search_isbn'
    end
    member do
      get 'editions'
      post 'add_existing_editions'
      post 'add_isbn'
    end
  end

  resources :grade_levels do
    resources :grade_sections, shallow: true do
      member do
        get 'students'
        post 'add_students'
      end
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get :dashboard, to: 'welcome#dashboard'
  
  # For authorization with OmniAuth2
  get '/auth/:provider/callback', to: 'sessions#create'

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
