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

ActiveRecord::Schema[7.1].define(version: 2024_02_22_103533) do
  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "user_type", null: false
    t.integer "user_id", null: false
    t.string "post_type", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_type", "post_id"], name: "index_comments_on_post"
    t.index ["user_type", "user_id"], name: "index_comments_on_user"
  end

  create_table "likes", force: :cascade do |t|
    t.string "user_type", null: false
    t.integer "user_id", null: false
    t.string "likeable_type", null: false
    t.integer "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "like_status"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_type", "user_id"], name: "index_likes_on_user"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.string "user_type", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type", "user_id"], name: "index_posts_on_user"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
