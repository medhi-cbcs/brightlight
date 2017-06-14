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

ActiveRecord::Schema.define(version: 20170613074207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_terms", force: :cascade do |t|
    t.integer  "academic_year_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "academic_terms", ["academic_year_id"], name: "index_academic_terms_on_academic_year_id", using: :btree

  create_table "academic_terms_courses", id: false, force: :cascade do |t|
    t.integer "academic_term_id"
    t.integer "course_id"
  end

  add_index "academic_terms_courses", ["academic_term_id"], name: "index_academic_terms_courses_on_academic_term_id", using: :btree
  add_index "academic_terms_courses", ["course_id"], name: "index_academic_terms_courses_on_course_id", using: :btree

  create_table "academic_years", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  add_index "academic_years", ["slug"], name: "index_academic_years_on_slug", unique: true, using: :btree

  create_table "attachment_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
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
    t.integer  "grade_section_id"
  end

  add_index "book_assignments", ["academic_year_id"], name: "index_book_assignments_on_academic_year_id", using: :btree
  add_index "book_assignments", ["book_copy_id"], name: "index_book_assignments_on_book_copy_id", using: :btree
  add_index "book_assignments", ["course_text_id"], name: "index_book_assignments_on_course_text_id", using: :btree
  add_index "book_assignments", ["grade_section_id"], name: "index_book_assignments_on_grade_section_id", using: :btree
  add_index "book_assignments", ["status_id"], name: "index_book_assignments_on_status_id", using: :btree
  add_index "book_assignments", ["student_id"], name: "index_book_assignments_on_student_id", using: :btree

  create_table "book_categories", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_conditions", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.integer  "order_no"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "color"
    t.string   "slug"
  end

  add_index "book_conditions", ["slug"], name: "index_book_conditions_on_slug", unique: true, using: :btree

  create_table "book_copies", force: :cascade do |t|
    t.integer  "book_edition_id"
    t.integer  "book_condition_id"
    t.integer  "status_id"
    t.string   "barcode"
    t.string   "copy_no"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "book_label_id"
    t.string   "slug"
    t.boolean  "needs_repair"
    t.string   "notes"
    t.boolean  "disposed"
    t.date     "disposed_at"
  end

  add_index "book_copies", ["barcode"], name: "index_book_copies_on_barcode", unique: true, using: :btree
  add_index "book_copies", ["book_condition_id"], name: "index_book_copies_on_book_condition_id", using: :btree
  add_index "book_copies", ["book_edition_id"], name: "index_book_copies_on_book_edition_id", using: :btree
  add_index "book_copies", ["book_label_id"], name: "index_book_copies_on_book_label_id", using: :btree
  add_index "book_copies", ["slug"], name: "index_book_copies_on_slug", unique: true, using: :btree
  add_index "book_copies", ["status_id"], name: "index_book_copies_on_status_id", using: :btree

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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "book_title_id"
    t.decimal  "price"
    t.string   "currency"
    t.integer  "attachment_index"
    t.string   "attachment_name"
    t.integer  "attachment_qty"
    t.string   "refno"
    t.string   "slug"
    t.string   "legacy_code"
  end

  add_index "book_editions", ["book_title_id"], name: "index_book_editions_on_book_title_id", using: :btree
  add_index "book_editions", ["slug"], name: "index_book_editions_on_slug", unique: true, using: :btree

  create_table "book_fines", force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "old_condition_id"
    t.integer  "new_condition_id"
    t.decimal  "fine"
    t.integer  "academic_year_id"
    t.integer  "student_id"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "percentage"
    t.string   "currency"
    t.integer  "grade_level_id"
    t.integer  "grade_section_id"
    t.integer  "student_book_id"
    t.boolean  "paid"
  end

  add_index "book_fines", ["academic_year_id"], name: "index_book_fines_on_academic_year_id", using: :btree
  add_index "book_fines", ["book_copy_id"], name: "index_book_fines_on_book_copy_id", using: :btree
  add_index "book_fines", ["grade_level_id"], name: "index_book_fines_on_grade_level_id", using: :btree
  add_index "book_fines", ["grade_section_id"], name: "index_book_fines_on_grade_section_id", using: :btree
  add_index "book_fines", ["student_book_id"], name: "index_book_fines_on_student_book_id", using: :btree
  add_index "book_fines", ["student_id"], name: "index_book_fines_on_student_id", using: :btree

  create_table "book_labels", force: :cascade do |t|
    t.integer  "grade_level_id"
    t.integer  "student_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "grade_section_id"
    t.string   "slug"
    t.integer  "book_no"
  end

  add_index "book_labels", ["grade_level_id"], name: "index_book_labels_on_grade_level_id", using: :btree
  add_index "book_labels", ["grade_section_id"], name: "index_book_labels_on_grade_section_id", using: :btree
  add_index "book_labels", ["slug"], name: "index_book_labels_on_slug", unique: true, using: :btree
  add_index "book_labels", ["student_id"], name: "index_book_labels_on_student_id", using: :btree

  create_table "book_loan_histories", force: :cascade do |t|
    t.integer  "book_title_id"
    t.integer  "book_edition_id"
    t.integer  "book_copy_id"
    t.integer  "user_id"
    t.date     "out_date"
    t.date     "due_date"
    t.date     "in_date"
    t.integer  "condition_out_id"
    t.integer  "condition_in_id"
    t.float    "fine_assessed"
    t.float    "fine_paid"
    t.float    "fine_waived"
    t.string   "remarks"
    t.integer  "academic_year_id"
    t.integer  "update_by_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "book_loan_histories", ["academic_year_id"], name: "index_book_loan_histories_on_academic_year_id", using: :btree
  add_index "book_loan_histories", ["book_copy_id"], name: "index_book_loan_histories_on_book_copy_id", using: :btree
  add_index "book_loan_histories", ["book_edition_id"], name: "index_book_loan_histories_on_book_edition_id", using: :btree
  add_index "book_loan_histories", ["book_title_id"], name: "index_book_loan_histories_on_book_title_id", using: :btree
  add_index "book_loan_histories", ["condition_in_id"], name: "index_book_loan_histories_on_condition_in_id", using: :btree
  add_index "book_loan_histories", ["condition_out_id"], name: "index_book_loan_histories_on_condition_out_id", using: :btree
  add_index "book_loan_histories", ["update_by_id"], name: "index_book_loan_histories_on_update_by_id", using: :btree
  add_index "book_loan_histories", ["user_id"], name: "index_book_loan_histories_on_user_id", using: :btree

  create_table "book_loans", force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "book_edition_id"
    t.integer  "book_title_id"
    t.integer  "person_id"
    t.integer  "book_category_id"
    t.integer  "loan_type_id"
    t.date     "out_date"
    t.date     "due_date"
    t.integer  "academic_year_id"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "student_no"
    t.string   "roster_no"
    t.string   "barcode"
    t.string   "refno"
    t.string   "grade_section_code"
    t.string   "grade_subject_code"
    t.string   "notes"
    t.integer  "prev_academic_year_id"
    t.string   "loan_status"
    t.string   "return_status"
    t.string   "bkudid"
    t.date     "return_date"
    t.integer  "employee_id"
    t.string   "employee_no"
    t.integer  "student_id"
    t.boolean  "deleted_flag"
  end

  add_index "book_loans", ["academic_year_id"], name: "index_book_loans_on_academic_year_id", using: :btree
  add_index "book_loans", ["book_category_id"], name: "index_book_loans_on_book_category_id", using: :btree
  add_index "book_loans", ["book_copy_id"], name: "index_book_loans_on_book_copy_id", using: :btree
  add_index "book_loans", ["book_edition_id"], name: "index_book_loans_on_book_edition_id", using: :btree
  add_index "book_loans", ["book_title_id"], name: "index_book_loans_on_book_title_id", using: :btree
  add_index "book_loans", ["employee_id"], name: "index_book_loans_on_employee_id", using: :btree
  add_index "book_loans", ["loan_type_id"], name: "index_book_loans_on_loan_type_id", using: :btree
  add_index "book_loans", ["person_id"], name: "index_book_loans_on_person_id", using: :btree
  add_index "book_loans", ["prev_academic_year_id"], name: "index_book_loans_on_prev_academic_year_id", using: :btree
  add_index "book_loans", ["student_id"], name: "index_book_loans_on_student_id", using: :btree
  add_index "book_loans", ["user_id"], name: "index_book_loans_on_user_id", using: :btree

  create_table "book_receipts", force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "academic_year_id"
    t.integer  "student_id"
    t.integer  "book_edition_id"
    t.integer  "grade_section_id"
    t.integer  "grade_level_id"
    t.integer  "roster_no"
    t.string   "copy_no"
    t.date     "issue_date"
    t.integer  "initial_condition_id"
    t.integer  "return_condition_id"
    t.string   "barcode"
    t.string   "notes"
    t.string   "grade_section_code"
    t.string   "grade_subject_code"
    t.integer  "course_id"
    t.integer  "course_text_id"
    t.boolean  "active"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "book_receipts", ["academic_year_id"], name: "index_book_receipts_on_academic_year_id", using: :btree
  add_index "book_receipts", ["book_copy_id"], name: "index_book_receipts_on_book_copy_id", using: :btree
  add_index "book_receipts", ["book_edition_id"], name: "index_book_receipts_on_book_edition_id", using: :btree
  add_index "book_receipts", ["course_id"], name: "index_book_receipts_on_course_id", using: :btree
  add_index "book_receipts", ["course_text_id"], name: "index_book_receipts_on_course_text_id", using: :btree
  add_index "book_receipts", ["grade_level_id"], name: "index_book_receipts_on_grade_level_id", using: :btree
  add_index "book_receipts", ["grade_section_id"], name: "index_book_receipts_on_grade_section_id", using: :btree
  add_index "book_receipts", ["initial_condition_id"], name: "index_book_receipts_on_initial_condition_id", using: :btree
  add_index "book_receipts", ["return_condition_id"], name: "index_book_receipts_on_return_condition_id", using: :btree
  add_index "book_receipts", ["student_id"], name: "index_book_receipts_on_student_id", using: :btree

  create_table "book_titles", force: :cascade do |t|
    t.string   "title"
    t.string   "authors"
    t.string   "publisher"
    t.string   "image_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "bkudid"
    t.integer  "subject_id"
    t.string   "subject_code"
    t.string   "slug"
    t.string   "subject_level"
    t.string   "grade_code"
  end

  add_index "book_titles", ["slug"], name: "index_book_titles_on_slug", unique: true, using: :btree
  add_index "book_titles", ["subject_id"], name: "index_book_titles_on_subject_id", using: :btree

  create_table "carpools", force: :cascade do |t|
    t.string   "category"
    t.integer  "transport_id"
    t.string   "barcode"
    t.string   "transport_name"
    t.string   "period"
    t.float    "sort_order"
    t.boolean  "active"
    t.string   "status"
    t.datetime "arrival"
    t.datetime "departure"
    t.string   "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "carpools", ["barcode"], name: "index_carpools_on_barcode", using: :btree
  add_index "carpools", ["sort_order"], name: "index_carpools_on_sort_order", using: :btree
  add_index "carpools", ["transport_id"], name: "index_carpools_on_transport_id", using: :btree

  create_table "copy_conditions", force: :cascade do |t|
    t.integer  "book_copy_id"
    t.integer  "book_condition_id"
    t.integer  "academic_year_id"
    t.string   "barcode"
    t.string   "notes"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "post"
    t.boolean  "deleted_flag"
  end

  add_index "copy_conditions", ["academic_year_id"], name: "index_copy_conditions_on_academic_year_id", using: :btree
  add_index "copy_conditions", ["book_condition_id"], name: "index_copy_conditions_on_book_condition_id", using: :btree
  add_index "copy_conditions", ["book_copy_id"], name: "index_copy_conditions_on_book_copy_id", using: :btree
  add_index "copy_conditions", ["user_id"], name: "index_copy_conditions_on_user_id", using: :btree

  create_table "course_section_histories", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "grade_section_id"
    t.integer  "instructor_id"
    t.integer  "academic_year_id"
    t.integer  "academic_term_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "course_section_histories", ["academic_term_id"], name: "index_course_section_histories_on_academic_term_id", using: :btree
  add_index "course_section_histories", ["academic_year_id"], name: "index_course_section_histories_on_academic_year_id", using: :btree
  add_index "course_section_histories", ["course_id"], name: "index_course_section_histories_on_course_id", using: :btree
  add_index "course_section_histories", ["grade_section_id"], name: "index_course_section_histories_on_grade_section_id", using: :btree
  add_index "course_section_histories", ["instructor_id"], name: "index_course_section_histories_on_instructor_id", using: :btree

  create_table "course_sections", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "grade_section_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "instructor_id"
    t.string   "slug"
  end

  add_index "course_sections", ["course_id"], name: "index_course_sections_on_course_id", using: :btree
  add_index "course_sections", ["grade_section_id"], name: "index_course_sections_on_grade_section_id", using: :btree
  add_index "course_sections", ["instructor_id"], name: "index_course_sections_on_instructor_id", using: :btree
  add_index "course_sections", ["slug"], name: "index_course_sections_on_slug", unique: true, using: :btree

  create_table "course_texts", force: :cascade do |t|
    t.integer "course_id"
    t.integer "book_title_id"
    t.integer "order_no"
  end

  add_index "course_texts", ["book_title_id"], name: "index_course_texts_on_book_title_id", using: :btree
  add_index "course_texts", ["course_id"], name: "index_course_texts_on_course_id", using: :btree

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
    t.string   "slug"
  end

  add_index "courses", ["academic_term_id"], name: "index_courses_on_academic_term_id", using: :btree
  add_index "courses", ["academic_year_id"], name: "index_courses_on_academic_year_id", using: :btree
  add_index "courses", ["employee_id"], name: "index_courses_on_employee_id", using: :btree
  add_index "courses", ["grade_level_id"], name: "index_courses_on_grade_level_id", using: :btree
  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string   "foreign"
    t.string   "base"
    t.float    "rate"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "currencies", ["user_id"], name: "index_currencies_on_user_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "manager_id"
    t.string   "slug"
  end

  add_index "departments", ["manager_id"], name: "index_departments_on_manager_id", using: :btree
  add_index "departments", ["slug"], name: "index_departments_on_slug", unique: true, using: :btree

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
    t.string   "slug"
    t.string   "nick_name"
    t.boolean  "is_active"
    t.integer  "family_no"
    t.integer  "user_id"
  end

  add_index "employees", ["department_id"], name: "index_employees_on_department_id", using: :btree
  add_index "employees", ["slug"], name: "index_employees_on_slug", unique: true, using: :btree
  add_index "employees", ["supervisor_id"], name: "index_employees_on_supervisor_id", using: :btree
  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "families", force: :cascade do |t|
    t.string   "family_no"
    t.integer  "family_number"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "families", ["family_no"], name: "index_families_on_family_no", using: :btree
  add_index "families", ["family_number"], name: "index_families_on_family_number", using: :btree

  create_table "family_members", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "guardian_id"
    t.integer  "student_id"
    t.string   "relation"
    t.string   "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "family_members", ["family_id"], name: "index_family_members_on_family_id", using: :btree
  add_index "family_members", ["guardian_id"], name: "index_family_members_on_guardian_id", using: :btree
  add_index "family_members", ["student_id"], name: "index_family_members_on_student_id", using: :btree

  create_table "fine_scales", force: :cascade do |t|
    t.integer  "old_condition_id"
    t.integer  "new_condition_id"
    t.float    "percentage"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "fine_scales", ["new_condition_id"], name: "index_fine_scales_on_new_condition_id", using: :btree
  add_index "fine_scales", ["old_condition_id"], name: "index_fine_scales_on_old_condition_id", using: :btree

  create_table "grade_levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "order_no"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "school_level_id"
    t.string   "code"
    t.string   "slug"
  end

  add_index "grade_levels", ["school_level_id"], name: "index_grade_levels_on_school_level_id", using: :btree
  add_index "grade_levels", ["slug"], name: "index_grade_levels_on_slug", unique: true, using: :btree

  create_table "grade_section_histories", force: :cascade do |t|
    t.integer  "grade_level_id"
    t.integer  "grade_section_id"
    t.integer  "academic_year_id"
    t.integer  "homeroom_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "assistant_id"
    t.string   "subject_code"
    t.string   "parallel_code"
    t.string   "notes"
    t.integer  "capacity"
  end

  add_index "grade_section_histories", ["academic_year_id"], name: "index_grade_section_histories_on_academic_year_id", using: :btree
  add_index "grade_section_histories", ["assistant_id"], name: "index_grade_section_histories_on_assistant_id", using: :btree
  add_index "grade_section_histories", ["grade_level_id"], name: "index_grade_section_histories_on_grade_level_id", using: :btree
  add_index "grade_section_histories", ["grade_section_id"], name: "index_grade_section_histories_on_grade_section_id", using: :btree
  add_index "grade_section_histories", ["homeroom_id"], name: "index_grade_section_histories_on_homeroom_id", using: :btree

  create_table "grade_sections", force: :cascade do |t|
    t.integer  "grade_level_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "homeroom_id"
    t.integer  "academic_year_id"
    t.string   "slug"
    t.integer  "assistant_id"
    t.string   "subject_code"
    t.string   "parallel_code"
    t.string   "notes"
    t.integer  "capacity"
  end

  add_index "grade_sections", ["academic_year_id"], name: "index_grade_sections_on_academic_year_id", using: :btree
  add_index "grade_sections", ["assistant_id"], name: "index_grade_sections_on_assistant_id", using: :btree
  add_index "grade_sections", ["grade_level_id"], name: "index_grade_sections_on_grade_level_id", using: :btree
  add_index "grade_sections", ["homeroom_id"], name: "index_grade_sections_on_homeroom_id", using: :btree
  add_index "grade_sections", ["slug"], name: "index_grade_sections_on_slug", unique: true, using: :btree

  create_table "grade_sections_students", force: :cascade do |t|
    t.integer  "grade_section_id"
    t.integer  "student_id"
    t.integer  "order_no"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "academic_year_id"
    t.integer  "grade_section_history_id"
    t.string   "notes"
    t.string   "track"
  end

  add_index "grade_sections_students", ["academic_year_id"], name: "index_grade_sections_students_on_academic_year_id", using: :btree
  add_index "grade_sections_students", ["grade_section_history_id"], name: "index_grade_sections_students_on_grade_section_history_id", using: :btree
  add_index "grade_sections_students", ["grade_section_id"], name: "index_grade_sections_students_on_grade_section_id", using: :btree
  add_index "grade_sections_students", ["student_id"], name: "index_grade_sections_students_on_student_id", using: :btree

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
    t.integer  "family_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "person_id"
    t.string   "slug"
    t.string   "email"
    t.string   "email2"
  end

  add_index "guardians", ["person_id"], name: "index_guardians_on_person_id", using: :btree
  add_index "guardians", ["slug"], name: "index_guardians_on_slug", unique: true, using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "invoice_number"
    t.date     "invoice_date"
    t.string   "bill_to"
    t.integer  "student_id"
    t.string   "grade_section"
    t.string   "roster_no"
    t.string   "total_amount"
    t.string   "received_by"
    t.string   "paid_by"
    t.string   "paid_amount"
    t.string   "currency"
    t.string   "notes"
    t.boolean  "paid"
    t.string   "statuses"
    t.string   "tag"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "academic_year_id"
  end

  add_index "invoices", ["academic_year_id"], name: "index_invoices_on_academic_year_id", using: :btree
  add_index "invoices", ["student_id"], name: "index_invoices_on_student_id", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "late_passengers", force: :cascade do |t|
    t.integer  "carpool_id"
    t.integer  "transport_id"
    t.integer  "student_id"
    t.integer  "grade_section_id"
    t.string   "name"
    t.string   "family_no"
    t.integer  "family_id"
    t.string   "class_name"
    t.boolean  "active"
    t.string   "notes"
    t.datetime "since_time"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "late_passengers", ["carpool_id"], name: "index_late_passengers_on_carpool_id", using: :btree
  add_index "late_passengers", ["grade_section_id"], name: "index_late_passengers_on_grade_section_id", using: :btree
  add_index "late_passengers", ["student_id"], name: "index_late_passengers_on_student_id", using: :btree
  add_index "late_passengers", ["transport_id"], name: "index_late_passengers_on_transport_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.string   "description"
    t.string   "quantity"
    t.string   "price"
    t.string   "ext1"
    t.string   "ext2"
    t.string   "ext3"
    t.string   "notes"
    t.string   "status"
    t.integer  "invoice_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "book_fine_id"
  end

  add_index "line_items", ["book_fine_id"], name: "index_line_items_on_book_fine_id", using: :btree
  add_index "line_items", ["invoice_id"], name: "index_line_items_on_invoice_id", using: :btree

  create_table "loan_checks", force: :cascade do |t|
    t.integer  "book_loan_id"
    t.integer  "book_copy_id"
    t.integer  "user_id"
    t.integer  "loaned_to"
    t.integer  "scanned_for"
    t.integer  "academic_year_id"
    t.boolean  "emp_flag"
    t.boolean  "matched"
    t.string   "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "loan_checks", ["academic_year_id"], name: "index_loan_checks_on_academic_year_id", using: :btree
  add_index "loan_checks", ["book_copy_id"], name: "index_loan_checks_on_book_copy_id", using: :btree
  add_index "loan_checks", ["book_loan_id"], name: "index_loan_checks_on_book_loan_id", using: :btree
  add_index "loan_checks", ["user_id"], name: "index_loan_checks_on_user_id", using: :btree

  create_table "loan_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passengers", force: :cascade do |t|
    t.integer  "transport_id"
    t.integer  "student_id"
    t.string   "name"
    t.string   "family_no"
    t.integer  "family_id"
    t.integer  "grade_section_id"
    t.string   "class_name"
    t.boolean  "active"
    t.string   "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "passengers", ["family_no"], name: "index_passengers_on_family_no", using: :btree
  add_index "passengers", ["grade_section_id"], name: "index_passengers_on_grade_section_id", using: :btree
  add_index "passengers", ["student_id"], name: "index_passengers_on_student_id", using: :btree
  add_index "passengers", ["transport_id"], name: "index_passengers_on_transport_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "full_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name"
    t.date     "date_of_birth"
    t.string   "place_of_birth"
    t.string   "gender"
    t.string   "passport_no"
    t.string   "blood_type"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "other_phone"
    t.string   "email"
    t.string   "other_email"
    t.string   "bbm_pin"
    t.string   "sm_twitter"
    t.string   "sm_facebook"
    t.string   "sm_line"
    t.string   "sm_path"
    t.string   "sm_instagram"
    t.string   "sm_google_plus"
    t.string   "sm_linked_in"
    t.string   "gravatar"
    t.string   "photo_uri"
    t.string   "nationality"
    t.string   "religion"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "kecamatan"
    t.string   "kabupaten"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
  end

  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

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

  create_table "rosters", force: :cascade do |t|
    t.integer  "course_section_id"
    t.integer  "student_id"
    t.integer  "academic_year_id"
    t.integer  "order_no"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "rosters", ["academic_year_id"], name: "index_rosters_on_academic_year_id", using: :btree
  add_index "rosters", ["course_section_id"], name: "index_rosters_on_course_section_id", using: :btree
  add_index "rosters", ["student_id"], name: "index_rosters_on_student_id", using: :btree

  create_table "school_levels", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_terms", force: :cascade do |t|
    t.integer  "academic_year_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "school_terms", ["academic_year_id"], name: "index_school_terms_on_academic_year_id", using: :btree

  create_table "school_years", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "smart_cards", force: :cascade do |t|
    t.string   "code"
    t.integer  "transport_id"
    t.string   "detail"
    t.string   "ref"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "smart_cards", ["transport_id"], name: "index_smart_cards_on_transport_id", using: :btree

  create_table "standard_books", force: :cascade do |t|
    t.integer  "book_title_id"
    t.integer  "book_edition_id"
    t.integer  "book_category_id"
    t.integer  "grade_level_id"
    t.integer  "grade_section_id"
    t.integer  "academic_year_id"
    t.string   "isbn"
    t.string   "refno"
    t.integer  "quantity"
    t.string   "grade_subject_code"
    t.string   "grade_name"
    t.string   "group"
    t.string   "category"
    t.string   "bkudid"
    t.string   "notes"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "track"
  end

  add_index "standard_books", ["academic_year_id"], name: "index_standard_books_on_academic_year_id", using: :btree
  add_index "standard_books", ["book_category_id"], name: "index_standard_books_on_book_category_id", using: :btree
  add_index "standard_books", ["book_edition_id"], name: "index_standard_books_on_book_edition_id", using: :btree
  add_index "standard_books", ["book_title_id"], name: "index_standard_books_on_book_title_id", using: :btree
  add_index "standard_books", ["grade_level_id"], name: "index_standard_books_on_grade_level_id", using: :btree
  add_index "standard_books", ["grade_section_id"], name: "index_standard_books_on_grade_section_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string  "name"
    t.integer "order_no"
  end

  create_table "student_admission_infos", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "academic_year_id"
    t.string   "skhun"
    t.string   "skhun_date"
    t.string   "diploma"
    t.string   "diploma_date"
    t.string   "acceptance_date_1"
    t.string   "acceptance_date_2"
    t.string   "nisn"
    t.string   "duration"
    t.string   "reason"
    t.string   "status"
    t.string   "notes"
    t.string   "prev_sch_name"
    t.string   "prev_sch_grade"
    t.string   "prev_sch_address"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "student_admission_infos", ["academic_year_id"], name: "index_student_admission_infos_on_academic_year_id", using: :btree
  add_index "student_admission_infos", ["student_id"], name: "index_student_admission_infos_on_student_id", using: :btree

  create_table "student_books", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "book_copy_id"
    t.integer  "academic_year_id"
    t.integer  "course_text_id"
    t.string   "copy_no"
    t.integer  "grade_section_id"
    t.integer  "grade_level_id"
    t.integer  "course_id"
    t.date     "issue_date"
    t.date     "return_date"
    t.integer  "initial_copy_condition_id"
    t.integer  "end_copy_condition_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "barcode"
    t.string   "student_no"
    t.string   "roster_no"
    t.string   "grade_section_code"
    t.string   "grade_subject_code"
    t.string   "notes"
    t.integer  "prev_academic_year_id"
    t.integer  "book_edition_id"
    t.boolean  "deleted_flag"
    t.boolean  "needs_rebinding"
    t.integer  "book_loan_id"
  end

  add_index "student_books", ["academic_year_id"], name: "index_student_books_on_academic_year_id", using: :btree
  add_index "student_books", ["book_copy_id"], name: "index_student_books_on_book_copy_id", using: :btree
  add_index "student_books", ["book_edition_id"], name: "index_student_books_on_book_edition_id", using: :btree
  add_index "student_books", ["book_loan_id"], name: "index_student_books_on_book_loan_id", using: :btree
  add_index "student_books", ["course_id"], name: "index_student_books_on_course_id", using: :btree
  add_index "student_books", ["course_text_id"], name: "index_student_books_on_course_text_id", using: :btree
  add_index "student_books", ["grade_level_id"], name: "index_student_books_on_grade_level_id", using: :btree
  add_index "student_books", ["grade_section_id"], name: "index_student_books_on_grade_section_id", using: :btree
  add_index "student_books", ["prev_academic_year_id"], name: "index_student_books_on_prev_academic_year_id", using: :btree
  add_index "student_books", ["student_id"], name: "index_student_books_on_student_id", using: :btree

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
    t.string   "student_no"
    t.string   "passport_no"
    t.string   "enrollment_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "person_id"
    t.string   "nick_name"
    t.string   "family_no"
    t.float    "home_to_school_1"
    t.float    "home_to_school_2"
    t.integer  "siblings"
    t.integer  "adopted_siblings"
    t.integer  "step_siblings"
    t.integer  "birth_order"
    t.string   "transport"
    t.string   "parental_status"
    t.string   "parents_status"
    t.string   "address_rt"
    t.string   "address_rw"
    t.string   "address_kelurahan"
    t.string   "address_kecamatan"
    t.string   "living_with"
    t.string   "slug"
    t.string   "place_of_birth"
    t.string   "language"
  end

  add_index "students", ["family_no"], name: "index_students_on_family_no", using: :btree
  add_index "students", ["person_id"], name: "index_students_on_person_id", using: :btree
  add_index "students", ["slug"], name: "index_students_on_slug", unique: true, using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "template_targets", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.string   "header"
    t.string   "opening"
    t.string   "body"
    t.string   "closing"
    t.string   "footer"
    t.string   "target"
    t.string   "group"
    t.string   "category"
    t.string   "active"
    t.integer  "academic_year_id"
    t.integer  "user_id"
    t.string   "language"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "templates", ["academic_year_id"], name: "index_templates_on_academic_year_id", using: :btree
  add_index "templates", ["user_id"], name: "index_templates_on_user_id", using: :btree

  create_table "transports", force: :cascade do |t|
    t.string   "category"
    t.string   "name"
    t.string   "status"
    t.boolean  "active"
    t.string   "notes"
    t.integer  "contact_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "family_no"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "transports", ["family_no"], name: "index_transports_on_family_no", using: :btree

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
    t.integer  "roles_mask"
    t.string   "auth_token"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "book_fines", "grade_levels"
  add_foreign_key "book_fines", "grade_sections"
  add_foreign_key "book_fines", "student_books"
  add_foreign_key "carpools", "transports"
  add_foreign_key "course_section_histories", "employees", column: "instructor_id"
  add_foreign_key "currencies", "users"
  add_foreign_key "family_members", "families"
  add_foreign_key "family_members", "guardians"
  add_foreign_key "family_members", "students"
  add_foreign_key "invoices", "academic_years"
  add_foreign_key "invoices", "students"
  add_foreign_key "invoices", "users"
  add_foreign_key "late_passengers", "carpools"
  add_foreign_key "late_passengers", "grade_sections"
  add_foreign_key "late_passengers", "students"
  add_foreign_key "late_passengers", "transports"
  add_foreign_key "line_items", "book_fines"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "loan_checks", "academic_years"
  add_foreign_key "loan_checks", "book_copies"
  add_foreign_key "loan_checks", "book_loans"
  add_foreign_key "loan_checks", "users"
  add_foreign_key "passengers", "grade_sections"
  add_foreign_key "passengers", "students"
  add_foreign_key "passengers", "transports"
  add_foreign_key "smart_cards", "transports"
  add_foreign_key "templates", "academic_years"
  add_foreign_key "templates", "users"

  create_view :teachers_books,  sql_definition: <<-SQL
      SELECT book_loans.id,
      book_loans.book_copy_id,
      book_loans.book_edition_id,
      book_loans.book_title_id,
      book_loans.person_id,
      book_loans.book_category_id,
      book_loans.loan_type_id,
      book_loans.out_date,
      book_loans.due_date,
      book_loans.academic_year_id,
      book_loans.user_id,
      book_loans.created_at,
      book_loans.updated_at,
      book_loans.student_no,
      book_loans.roster_no,
      book_loans.barcode,
      book_loans.refno,
      book_loans.grade_section_code,
      book_loans.grade_subject_code,
      book_loans.notes,
      book_loans.prev_academic_year_id,
      book_loans.loan_status,
      book_loans.return_status,
      book_loans.bkudid,
      book_loans.return_date,
      book_loans.employee_id,
      book_loans.employee_no,
      book_loans.student_id,
      book_loans.deleted_flag,
      subjects.name AS subject,
      e.id AS edition_id,
      e.title,
      e.authors,
      e.isbn10,
      e.isbn13,
      e.publisher,
      e.small_thumbnail,
      l.id AS check_id,
      l.user_id AS checked_by,
      l.loaned_to,
      l.scanned_for,
      l.emp_flag,
      l.matched,
      l.notes AS check_notes,
      employees.id AS emp_id,
      employees.name AS emp_name
     FROM ((((((book_loans
       LEFT JOIN book_titles ON ((book_titles.id = book_loans.book_title_id)))
       LEFT JOIN book_editions e ON ((e.id = book_loans.book_edition_id)))
       LEFT JOIN subjects ON ((subjects.id = book_titles.subject_id)))
       LEFT JOIN employees ON ((employees.id = book_loans.employee_id)))
       LEFT JOIN ( SELECT loan_checks.book_loan_id,
              loan_checks.loaned_to,
              loan_checks.matched,
              loan_checks.academic_year_id,
              max(loan_checks.created_at) AS max_date
             FROM loan_checks
            GROUP BY loan_checks.loaned_to, loan_checks.matched, loan_checks.book_loan_id, loan_checks.academic_year_id) max_dates ON ((max_dates.book_loan_id = book_loans.id)))
       LEFT JOIN loan_checks l ON (((l.book_loan_id = book_loans.id) AND (l.academic_year_id = book_loans.academic_year_id) AND (l.loaned_to = book_loans.employee_id) AND (l.matched = true) AND (max_dates.book_loan_id = l.book_loan_id) AND (max_dates.max_date = l.created_at))));
  SQL

end
