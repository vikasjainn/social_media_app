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

ActiveRecord::Schema[7.1].define(version: 2024_03_10_122524) do
  create_table "account_verifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_account_verifications_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "blocked_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "blocked_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_user_id"], name: "index_blocked_users_on_blocked_user_id"
    t.index ["user_id"], name: "index_blocked_users_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "user_id", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "cooldown"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "url"
    t.string "imageable_type", null: false
    t.integer "imageable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "likeable_type", null: false
    t.integer "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "shares", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "article_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_shares_on_article_id"
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "refresh_token"
    t.string "profile_pic"
    t.string "cover_pic"
    t.integer "credits", default: 10
    t.boolean "premium", default: false
    t.index ["refresh_token"], name: "index_users_on_refresh_token"
  end

  add_foreign_key "account_verifications", "users"
  add_foreign_key "articles", "users"
  add_foreign_key "blocked_users", "users"
  add_foreign_key "blocked_users", "users", column: "blocked_user_id"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "shares", "articles"
  add_foreign_key "shares", "users"
end
