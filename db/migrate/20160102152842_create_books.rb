class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :genre, default: 0
      t.integer :author_id
      t.integer :user_id
      t.foreign_key :author, dependent: :delete
     	t.foreign_key :user, dependent: :nullify

      t.timestamps
    end
  end
end
