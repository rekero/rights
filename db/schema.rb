# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_05_121833) do
  create_table "albums", force: :cascade do |t|
    t.integer "artist_id"
    t.string "upc"
    t.string "release_title"
    t.integer "release_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.string "origin_type"
    t.integer "origin_id"
    t.integer "transaction_type_id"
    t.decimal "revenue_for_label", precision: 10, scale: 8
    t.decimal "revenue_for_artist", precision: 10, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["origin_type", "origin_id"], name: "index_sales_on_origin"
  end

  create_table "tracks", force: :cascade do |t|
    t.integer "album_id"
    t.integer "artist_id"
    t.string "isrc"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_types", force: :cascade do |t|
    t.string "name"
    t.decimal "proportion", precision: 10, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
