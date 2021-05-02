# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_02_152127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "genre"
    t.text "artist_url"
    t.text "tracks_url"
    t.text "self"
    t.string "artist_id"
  end

  create_table "artists", id: :string, force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.text "albums_url"
    t.text "tracks"
    t.text "self"
  end

  create_table "tracks", id: :string, force: :cascade do |t|
    t.string "name"
    t.float "duration"
    t.integer "times_played"
    t.text "artist"
    t.text "album_url"
    t.text "self"
    t.string "album_id"
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "tracks", "albums"
end
