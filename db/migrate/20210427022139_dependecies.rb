class Dependecies < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :artist_id, :string
    add_column :tracks, :album_id, :string
  end
end
