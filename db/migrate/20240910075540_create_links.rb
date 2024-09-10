class CreateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :links do |t|
      t.string :title
      t.text :url
      t.string :thumbnail
      t.integer :click
      t.integer :user_id

      t.timestamps
    end
  end
end
