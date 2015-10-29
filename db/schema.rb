# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151029115529) do

  create_table "academic_terms", force: :cascade do |t|
    t.integer  "academic_year_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "academic_terms", ["academic_year_id"], name: "index_academic_terms_on_academic_year_id"

  create_table "academic_years", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_assignments", id: false, force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "student_id"
    t.integer  "academic_year_id"
    t.integer  "course_text_id"
    t.date     "issue_date"
    t.date     "return_date"
    t.integer  "initial_condition_id"
    t.integer  "end_condition_id"
    t.integer  "status_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "book_assignments", ["academic_year_id"], name: "index_book_assignments_on_academic_year_id"
  add_index "book_assignments", ["book_copy_id"], name: "index_book_assignments_on_book_copy_id"
  add_index "book_assignments", ["course_text_id"], name: "index_book_assignments_on_course_text_id"
  add_index "book_assignments", ["status_id"], name: "index_book_assignments_on_status_id"
  add_index "book_assignments", ["student_id"], name: "index_book_assignments_on_student_id"

  create_table "book_conditions", id: false, force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.integer  "order_no"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "book_copies", force: :cascade do |t|
    t.integer  "book_edition_id"
    t.integer  "book_condition_id"
    t.integer  "status_id"
    t.string   "barcode"
    t.string   "copy_no"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "book_copies", ["book_condition_id"], name: "index_book_copies_on_book_condition_id"
  add_index "book_copies", ["book_edition_id"], name: "index_book_copies_on_book_edition_id"
  add_index "book_copies", ["status_id"], name: "index_book_copies_on_status_id"

  create_table "book_editions", force: :cascade do |t|
    t.string   "google_book_id"
    t.string   "isbndb_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "authors"
    t.string   "publisher"
    t.string   "published_date"
    t.string   "description"
    t.string   "isbn10"
    t.string   "isbn13"
    t.integer  "page_count"
    t.string   "small_thumbnail"
    t.string   "thumbnail"
    t.string   "language"
    t.string   "edition_info"
    t.string   "tags"
    t.string   "subjects"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "book_title_id"
  end

  add_index "book_editions", ["book_title_id"], name: "index_book_editions_on_book_title_id"

  create_table "book_grades", id: false, force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "book_condition_id"
    t.integer  "academic_year_id"
    t.string   "notes"
    t.integer  "graded_by"
    t.date     "checked_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "book_grades", ["academic_year_id"], name: "index_book_grades_on_academic_year_id"
  add_index "book_grades", ["book_condition_id"], name: "index_book_grades_on_book_condition_id"
  add_index "book_grades", ["book_copy_id"], name: "index_book_grades_on_book_copy_id"

  create_table "book_titles", force: :cascade do |t|
    t.string   "title"
    t.string   "authors"
    t.string   "publisher"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_sections", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "grade_section_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "instructor_id"
  end

  add_index "course_sections", ["course_id"], name: "index_course_sections_on_course_id"
  add_index "course_sections", ["grade_section_id"], name: "index_course_sections_on_grade_section_id"
  add_index "course_sections", ["instructor_id"], name: "index_course_sections_on_instructor_id"

  create_table "course_texts", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "book_title_id"
    t.integer "order_no"
  end

  add_index "course_texts", ["book_title_id"], name: "index_course_texts_on_book_title_id"
  add_index "course_texts", ["course_id"], name: "index_course_texts_on_course_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.string   "description"
    t.integer  "grade_level_id"
    t.integer  "academic_year_id"
    t.integer  "academic_term_id"
    t.integer  "employee_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "courses", ["academic_term_id"], name: "index_courses_on_academic_term_id"
  add_index "courses", ["academic_year_id"], name: "index_courses_on_academic_year_id"
  add_index "courses", ["employee_id"], name: "index_courses_on_employee_id"
  add_index "courses", ["grade_level_id"], name: "index_courses_on_grade_level_id"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "manager_id"
  end

  add_index "departments", ["manager_id"], name: "index_departments_on_manager_id"

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "place_of_birth"
    t.date     "joining_date"
    t.string   "job_title"
    t.string   "employee_number"
    t.string   "marital_status"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.string   "employment_status"
    t.integer  "children_count"
    t.string   "home_address_line1"
    t.string   "home_address_line2"
    t.string   "home_city"
    t.string   "home_state"
    t.string   "home_country"
    t.string   "home_postal_code"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "office_phone"
    t.string   "other_phone"
    t.string   "emergency_contact_number"
    t.string   "emergency_contact_name"
    t.string   "email"
    t.string   "photo_uri"
    t.string   "education_degree"
    t.date     "education_graduation_date"
    t.string   "education_school"
    t.string   "education_degree2"
    t.date     "education_graduation_date2"
    t.string   "education_school2"
    t.string   "nationality"
    t.string   "blood_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "supervisor_id"
    t.integer  "department_id"
  end

  add_index "employees", ["department_id"], name: "index_employees_on_department_id"
  add_index "employees", ["supervisor_id"], name: "index_employees_on_supervisor_id"

  create_table "grade_levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "order_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grade_sections", force: :cascade do |t|
    t.integer  "grade_level_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "homeroom_id"
  end

  add_index "grade_sections", ["grade_level_id"], name: "index_grade_sections_on_grade_level_id"
  add_index "grade_sections", ["homeroom_id"], name: "index_grade_sections_on_homeroom_id"

  create_table "grade_sections_students", id: false, force: :cascade do |t|
    t.integer  "grade_section_id"
    t.integer  "student_id"
    t.integer  "order_no"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "grade_sections_students", ["grade_section_id"], name: "index_grade_sections_students_on_grade_section_id"
  add_index "grade_sections_students", ["student_id"], name: "index_grade_sections_students_on_student_id"

  create_table "guardians", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "office_phone"
    t.string   "other_phone"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "family_no"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "expiry_date"
    t.date     "received_date"
  end

  create_table "school_terms", force: :cascade do |t|
    t.integer  "academic_year_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "school_terms", ["academic_year_id"], name: "index_school_terms_on_academic_year_id"

  create_table "school_years", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string  "name"
    t.integer "order_no"
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "admission_no"
    t.integer  "family_id"
    t.string   "gender"
    t.string   "blood_type"
    t.string   "nationality"
    t.string   "religion"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "email"
    t.string   "photo_uri"
    t.string   "status"
    t.string   "status_description"
    t.boolean  "is_active"
    t.boolean  "is_deleted"
    t.integer  "student_no"
    t.string   "passport_no"
    t.string   "enrollment_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "students_guardians", id: false, force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "guardian_id"
    t.string   "relation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "students_guardians", ["guardian_id"], name: "index_students_guardians_on_guardian_id"
  add_index "students_guardians", ["student_id"], name: "index_students_guardians_on_student_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "location"
    t.string   "image_url"
    t.string   "url"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
