class DeleteColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :artists, :created_at
    remove_column :artists, :updated_at
    remove_column :albums, :created_at
    remove_column :albums, :updated_at
    remove_column :tracks, :created_at
    remove_column :tracks, :updated_at
  end
end
