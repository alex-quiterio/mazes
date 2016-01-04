class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :nationality
      t.integer :user_id
     	t.foreign_key :user, dependent: :nullify

      t.timestamps
    end
    add_index :authors, :name, unique: true
  end
end
