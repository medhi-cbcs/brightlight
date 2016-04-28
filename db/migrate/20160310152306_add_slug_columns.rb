class AddSlugColumns < ActiveRecord::Migration
  def change
    add_column :academic_years, :slug, :string
    add_index  :academic_years, :slug, :unique => true
    add_column :book_copies, :slug, :string
    add_index  :book_copies, :slug, :unique => true
    add_column :book_editions, :slug, :string
    add_index  :book_editions, :slug, :unique => true
    add_column :book_labels, :slug, :string
    add_index  :book_labels, :slug, :unique => true
    add_column :book_titles, :slug, :string
    add_index  :book_titles, :slug, :unique => true
    add_column :courses, :slug, :string
    add_index  :courses, :slug, :unique => true
    add_column :course_sections, :slug, :string
    add_index  :course_sections, :slug, :unique => true
    add_column :departments, :slug, :string
    add_index  :departments, :slug, :unique => true
    add_column :employees, :slug, :string
    add_index  :employees, :slug, :unique => true
    add_column :grade_levels, :slug, :string
    add_index  :grade_levels, :slug, :unique => true
    add_column :grade_sections, :slug, :string
    add_index  :grade_sections, :slug, :unique => true
    add_column :guardians, :slug, :string
    add_index  :guardians, :slug, :unique => true
    add_column :students, :slug, :string
    add_index  :students, :slug, :unique => true
  end
end
