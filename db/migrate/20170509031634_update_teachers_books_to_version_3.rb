class UpdateTeachersBooksToVersion3 < ActiveRecord::Migration
  def change
    update_view :teachers_books, version: 3, revert_to_version: 2
  end
end
