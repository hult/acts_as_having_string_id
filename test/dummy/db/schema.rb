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

ActiveRecord::Schema.define(version: 20170517134233) do

  create_table "as", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "f_id"
  end

  create_table "as_ds", force: :cascade do |t|
    t.integer  "a_id"
    t.integer  "d_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["a_id"], name: "index_as_ds_on_a_id"
    t.index ["d_id"], name: "index_as_ds_on_d_id"
  end

  create_table "bs", force: :cascade do |t|
    t.integer  "a_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["a_id"], name: "index_bs_on_a_id"
  end

  create_table "cs", force: :cascade do |t|
    t.integer  "b_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["b_id"], name: "index_cs_on_b_id"
  end

  create_table "ds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "es", force: :cascade do |t|
    t.integer  "a_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["a_id"], name: "index_es_on_a_id"
  end

  create_table "fs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
