class UpdateTeachersBooksToVersion2 < ActiveRecord::Migration
  def change
    update_view :teachers_books, version: 2, revert_to_version: 1
  end
end
