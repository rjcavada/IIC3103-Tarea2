class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists, id: false do |t|
      t.string :id
      t.string :name
      t.integer :age
      t.text :albums
      t.text :tracks
      t.text :self

      t.timestamps
    end
  end
end
