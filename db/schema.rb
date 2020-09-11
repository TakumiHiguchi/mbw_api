# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_11_040810) do

  create_table "article_requests", force: :cascade do |t|
    t.integer "writer_id"
    t.string "key"
    t.string "title"
    t.text "content"
    t.integer "requestType", default: 0
    t.integer "status", default: 0
    t.integer "count", default: 2000
    t.integer "maxAge", default: 0
    t.integer "submissionTime", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "key"
    t.text "description"
    t.string "thumbnail"
    t.integer "releaseTime"
    t.boolean "isIndex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lyrics", force: :cascade do |t|
    t.string "key"
    t.string "title"
    t.string "artist"
    t.string "jucket"
    t.string "lyricist"
    t.string "composer"
    t.text "lyrics"
    t.string "amazonUrl"
    t.string "iTunesUrl"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "writer_id"
    t.integer "unsettled", default: 0
    t.integer "confirm", default: 0
    t.integer "paid", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plan_registers", force: :cascade do |t|
    t.string "email"
    t.string "key"
    t.integer "maxAge"
    t.string "name"
    t.string "session"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unapproved_articles", force: :cascade do |t|
    t.integer "article_request_id"
    t.string "title"
    t.text "content"
    t.string "key"
    t.text "description"
    t.string "thumbnail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "writters", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "session"
    t.integer "maxAge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
