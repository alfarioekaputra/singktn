class CreateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :links, id: :uuid do |t|
      t.string :title
      t.text :url
      t.integer :click, default: 0
      t.string :short_url
      t.boolean :status, default: true
      t.references :user, type: :uuid, foreign_key: true
      t.index ["short_url"], name: "index_short_url_on_links", unique: true
      t.timestamps
      
    end
  end
end
