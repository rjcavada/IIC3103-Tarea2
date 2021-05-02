class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :artists, :albums, :albums_url
    rename_column :albums, :artist, :artist_url
    rename_column :albums, :tracks, :tracks_url
    rename_column :tracks, :album, :album_url
  end
end
