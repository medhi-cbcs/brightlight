class UpdateTeachersBooksToVersion4 < ActiveRecord::Migration
  def change
    update_view :teachers_books, version: 4, revert_to_version: 3
  end
end
