class AddShortUrlAndStatusToLinks < ActiveRecord::Migration[7.2]
  def change
    add_column :links, :short_url, :string
    add_column :links, :status, :boolean, default: true
  end
end
