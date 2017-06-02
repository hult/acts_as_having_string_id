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

ActiveRecord::Schema.define(version: 20170518083906) do

  create_table "as_ds", force: :cascade do |t|
    t.integer  "a_id"
    t.integer  "d_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["a_id"], name: "index_as_ds_on_a_id"
    t.index ["d_id"], name: "index_as_ds_on_d_id"
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_publishers", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["author_id"], name: "index_authors_publishers_on_author_id"
    t.index ["publisher_id"], name: "index_authors_publishers_on_publisher_id"
  end

  create_table "books", force: :cascade do |t|
    t.integer  "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  create_table "covers", force: :cascade do |t|
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_covers_on_book_id"
  end

  create_table "editions", force: :cascade do |t|
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_editions_on_book_id"
  end

  create_table "images", force: :cascade do |t|
    t.integer  "cover_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cover_id"], name: "index_images_on_cover_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
