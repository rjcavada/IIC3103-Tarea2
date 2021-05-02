class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks, id: false do |t|
      t.string :id
      t.string :name
      t.float :duration
      t.integer :times_played
      t.text :artist
      t.text :album
      t.text :self

      t.timestamps
    end
  end
end
