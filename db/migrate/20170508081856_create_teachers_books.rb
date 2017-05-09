class CreateTeachersBooks < ActiveRecord::Migration
  def change
    create_view :teachers_books
  end
end
