class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums, id: false do |t|
      t.string :id
      t.string :name
      t.string :genre
      t.text :artist
      t.text :tracks
      t.text :self

      t.timestamps
    end
  end
end
