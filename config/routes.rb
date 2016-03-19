Rails.application.routes.draw do

  resources :people
  resources :book_loans
  resources :attachment_types
  resources :book_categories
  resources :subjects
  resources :fine_scales
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
    resources :book_copies, shallow: true do
      collection do
        get 'edit_labels'
      end
    end
    member do
      get 'update_metadata'
    end
  end

  resources :copy_conditions do
    member do
      get 'check'
      post 'check_update'
    end
  end

  get 'book_copies/:id/conditions' => 'book_copies#conditions', as: :book_copy_conditions

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
      post 'update_metadata'
    end
  end

  resources :grade_levels do
    member do
      get 'edit_labels'
    end
    resources :grade_sections, shallow: true do
      member do
        get 'students'
        post 'add_students'
        get 'assign'
      end
    end
  end

  resources :student_books do
    collection do
      get 'assign'
      post 'label'
      get 'receipt_form'
    end
  end

  resources :book_fines do
    collection do
      get 'calculate'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  namespace :dynamic_select do
    get ':grade_level_id/grade_sections', to: 'options#grade_sections', as: 'grade_sections'
    get ':section/book_labels', to: 'options#book_labels', as: 'book_labels'
  end

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
