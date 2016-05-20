Rails.application.routes.draw do

  resources :templates
  resources :currencies
  resources :standard_books
  resources :people
  resources :book_categories
  resources :subjects
  resources :fine_scales
  resources :book_labels
  resources :rosters
  resources :departments
  resources :guardians
  resources :book_assignments
  resources :book_grades
  resources :academic_years
  resources :employees
  resources :copy_conditions

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

  get 'book_copies/:id/copy_conditions/check' => 'copy_conditions#check', as: :check_copy_condition
  post 'book_copies/:id/copy_conditions/check_update' => 'copy_conditions#check_update'
  get 'book_copies/:id/conditions' => 'book_copies#conditions', as: :book_copy_conditions
  get 'book_copies/:id/loans' => 'book_copies#loans', as: :book_copy_loans

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

  get 'student_books' => 'student_books#index', as: :all_student_books
  get 'student_books/assign' => 'student_books#assign', as: :assign_student_books
  get 'student_books/label' => 'student_books#label', as: :label_student_books
  get 'student_books/receipt_form' => 'student_books#receipt_form', as: :receipt_form_student_books
  get 'student_books/by_title' => 'student_books#by_title', as: :by_title_student_books
  get 'student_books/by_student' => 'student_books#by_student', as: :by_student_student_books
  put 'student_books/update_multiple' => 'student_books#update_multiple', as: :update_multiple_student_books
  get 'student_books/missing' => 'student_books#missing', as: :missing_student_books

  resources :students do
    resources :student_books, shallow: true
  end

  resources :book_loans, only: [:index] do
    collection do
      post 'search_student'
      post 'search_teacher'
    end
  end

  get  'students/:student_id/book_loans' => 'book_loans#index', as: :student_book_loans
  post 'students/:student_id/book_loans' => 'book_loans#create'
  get  'students/:student_id/book_loans/new' => 'book_loans#new', as: :new_student_book_loan
  get  'students/:student_id/book_loans/:id/edit' => 'book_loans#edit', as: :edit_student_book_loan
  get  'students/:student_id/book_loans/:id' => 'book_loans#show', as: :student_book_loan
  patch  'students/:student_id/book_loans/:id' => 'book_loans#update'
  put  'students/:student_id/book_loans/:id' => 'book_loans#update'
  delete  'students/:student_id/book_loans/:id' => 'book_loans#destroy'

  get  'employees/:employee_id/book_loans' => 'book_loans#index', as: :employee_book_loans
  post 'employees/:employee_id/book_loans' => 'book_loans#create'
  get  'employees/:employee_id/book_loans/new' => 'book_loans#new', as: :new_employee_book_loan
  get  'employees/:employee_id/book_loans/:id/edit' => 'book_loans#edit', as: :edit_employee_book_loan
  get  'employees/:employee_id/book_loans/:id' => 'book_loans#show', as: :employee_book_loan
  patch  'employees/:employee_id/book_loans/:id' => 'book_loans#update'
  put  'employees/:employee_id/book_loans/:id' => 'book_loans#update'
  delete  'employees/:employee_id/book_loans/:id' => 'book_loans#destroy'

  resources :book_fines do
    collection do
      get 'calculate'
      get 'current'
      get 'autocomplete_student_name'
      get 'notification'
      get 'payment'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  resources :users, only: [:index, :show, :edit, :update]

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
