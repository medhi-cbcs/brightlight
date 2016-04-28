class CreateAttachmentTypes < ActiveRecord::Migration
  def change
    create_table :attachment_types do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
