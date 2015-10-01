# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151001123948) do

  create_table "books", force: :cascade do |t|
    t.string   "google_book_id"
    t.string   "isbndb_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "authors"
    t.string   "publisher"
    t.string   "published_date"
    t.string   "description"
    t.string   "isbn10"
    t.string   "isbn13"
    t.integer  "page_count"
    t.string   "small_thumbnail"
    t.string   "thumbnail"
    t.string   "language"
    t.string   "edition_info"
    t.string   "tags"
    t.string   "subjects"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
