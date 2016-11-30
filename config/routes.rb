Rails.application.routes.draw do

  resources :template_targets
  resources :templates
  resources :currencies
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
  resources :book_conditions

  resources :courses do
    resources :course_texts, shallow: true
    resources :course_sections, except: :new, shallow: true
  end

  resources :book_editions do
    collection do
      get 'summary'
    end
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
  put 'book_copies/:id/copy_conditions/create' => 'copy_conditions#create', as: :create_book_copy_condition
  get 'book_copies/:id/conditions' => 'book_copies#conditions', as: :book_copy_conditions
  get 'book_copies/:id/loans' => 'book_copies#loans', as: :book_copy_loans
  get 'book_copies/:id/check_barcode' => 'book_copies#check_barcode', as: :book_copy_check_barcode
  post 'book_copies/dispose' => 'book_copies#dispose', as: :dispose_book_copies
  post 'book_copies/update_multiple' => 'book_copies#update_multiple', as: :update_multiple_book_copies

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

  # For some reasons this line should be placed before the "resources :standard_books" line for autocomplete to work
  get 'standard_books/autocomplete_book_edition_title' => 'standard_books/autocomplete_book_edition_title', as: :autocomplete_book_edition_title_standard_books

  resources :grade_levels do
    collection do
      get 'archive'
    end

    member do
      get 'edit_labels'
      post 'add_standard_books'
    end
    resources :grade_sections, shallow: true do
      member do
        get 'students'
        post 'add_students'
        get 'assign'
      end
    end

    resources :standard_books, shallow: true
  end

  resources :standard_books, only:[:index] do
    collection do
      post 'prepare'
    end
  end

  get 'grade_sections/:id/edit_labels' => 'grade_sections#edit_labels', as: :edit_labels_grade_section

  resources :grade_section_histories, only: [:index, :show]

  resources :invoices do
    resources :line_items
    member do
      patch 'finalize'
    end
  end

  get 'student_books' => 'student_books#index', as: :student_books
  get 'student_books/assign' => 'student_books#assign', as: :assign_student_books
  get 'student_books/label' => 'student_books#label', as: :label_student_books
  get 'student_books/receipt_form' => 'student_books#receipt_form', as: :receipt_form_student_books
  get 'student_books/by_title' => 'student_books#by_title', as: :by_title_student_books
  get 'student_books/by_student' => 'student_books#by_student', as: :by_student_student_books
  put 'student_books/update_multiple' => 'student_books#update_multiple', as: :update_multiple_student_books
  get 'student_books/missing' => 'student_books#missing', as: :missing_student_books
  get 'student_books/pnnrb' => 'student_books#pnnrb', as: :pnnrb_student_books
  post 'student_books/finalize' => 'student_books#finalize', as: :finalize_student_books
  post 'student_books/prepare_student_books' => 'student_books#prepare', as: :prepare_student_books

  resources :students do
    resources :student_books, shallow: true
  end

  # resources :book_loans
  resources :book_loans do
    collection do
      get 'teachers'
      post 'initialize_teachers'
      post 'move_all'
      get 'borrowers'
      get 'teacher_receipt'
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

  get  'employees/:employee_id/book_loans' => 'book_loans#list', as: :employee_book_loans
  get  'employees/:employee_id/teacher_receipt' => 'book_loans#teacher_receipt', as: :employee_book_loans_receipt
  post 'employees/:employee_id/book_loans' => 'book_loans#create_tm'
  get  'employees/:employee_id/book_loans/new' => 'book_loans#new_tm', as: :new_employee_book_loans
  get  'employees/:employee_id/book_loans/:id/edit' => 'book_loans#edit_tm', as: :edit_employee_book_loans
  get  'employees/:employee_id/book_loans/scan' => 'book_loans#scan', as: :scan_employee_book_loans
  get  'employees/:employee_id/book_loans/:id' => 'book_loans#show_tm', as: :employee_book_loan
  post 'employees/:employee_id/book_loans/list_action' => 'book_loans#list_action', as: :list_action_book_loans
  patch  'employees/:employee_id/book_loans/:id' => 'book_loans#update_tm'
  put  'employees/:employee_id/book_loans/:id' => 'book_loans#update_tm'
  delete  'employees/:employee_id/book_loans/:id' => 'book_loans#destroy_tm'

  get  'employees/:employee_id/loan_checks' => 'loan_checks#index', as: :employee_loan_checks
  get  'employees/:employee_id/loan_check/new' => 'loan_checks#new', as: :new_employee_loan_check
  post 'employees/:employee_id/loan_check' => 'loan_checks#create'
  delete  'employees/:employee_id/loan_check' => 'loan_checks#delete'

  resources :book_fines do
    collection do
      get 'calculate'
      get 'current'
      get 'autocomplete_student_name'
      get 'notification'
      get 'payment'
    end
  end

  resources :book_receipts do
    collection do
      post 'prepare'
      get  'check'
      post 'finalize_condition'
    end
  end

  resources :carpools do
    collection do
      get 'poll'
    end
  end

  resources :transports do
    member do
      get 'members'
      post 'add_members'
    end
  end

  resources :smart_cards, only: [:show, :create, :destroy]

  patch 'pax/:id' => 'late_passengers#update'

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  resources :users, only: [:index, :show, :edit, :update]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get :dashboard, to: 'welcome#dashboard'
  get :inventory_mtce, to: 'welcome#inventory_mtce'

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
