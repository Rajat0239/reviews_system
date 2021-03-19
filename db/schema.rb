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

ActiveRecord::Schema.define(version: 2021_03_19_061428) do

  create_table "asset_fields", force: :cascade do |t|
    t.integer "asset_id"
    t.string "field"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_asset_fields_on_asset_id"
  end

  create_table "asset_item_values", force: :cascade do |t|
    t.integer "asset_item_id"
    t.integer "asset_field_id"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_field_id"], name: "index_asset_item_values_on_asset_field_id"
    t.index ["asset_item_id"], name: "index_asset_item_values_on_asset_item_id"
  end

  create_table "asset_items", force: :cascade do |t|
    t.integer "asset_id"
    t.integer "asset_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["asset_id"], name: "index_asset_items_on_asset_id"
    t.index ["user_id"], name: "index_asset_items_on_user_id"
  end

  create_table "asset_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "asset_id"
    t.integer "asset_item_id"
    t.text "comment_by_user"
    t.text "comment_by_admin"
    t.string "request_type"
    t.string "status", default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_asset_requests_on_asset_id"
    t.index ["asset_item_id"], name: "index_asset_requests_on_asset_item_id"
    t.index ["user_id"], name: "index_asset_requests_on_user_id"
  end

  create_table "asset_tracks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "asset_item_id"
    t.datetime "assigned_on"
    t.datetime "submitted_on"
    t.index ["asset_item_id"], name: "index_asset_tracks_on_asset_item_id"
    t.index ["user_id"], name: "index_asset_tracks_on_user_id"
  end

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "feedback_by_reporting_users", force: :cascade do |t|
    t.integer "review_id"
    t.integer "user_id"
    t.integer "feedback_for_user_id"
    t.text "feedback"
    t.string "quarter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feedback_for_user_id"], name: "index_feedback_by_reporting_users_on_feedback_for_user_id"
    t.index ["review_id"], name: "index_feedback_by_reporting_users_on_review_id"
    t.index ["user_id"], name: "index_feedback_by_reporting_users_on_user_id"
  end

  create_table "question_for_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "question_id"
    t.string "quarter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "status", default: true
    t.index ["question_id"], name: "index_question_for_users_on_question_id"
    t.index ["role_id"], name: "index_question_for_users_on_role_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "q_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "question"
    t.integer "question_type_id"
    t.string "options"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "status", default: true
    t.index ["question_type_id"], name: "index_questions_on_question_type_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reporting_user_id"
    t.string "quarter"
    t.integer "ratings_by_reporting_user", default: 0
    t.integer "rating_by_admin", default: 0
    t.text "feedback_by_admin"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ratings_by_user", default: 0
    t.index ["reporting_user_id"], name: "index_ratings_on_reporting_user_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "ratings_of_user_for_himselves", force: :cascade do |t|
    t.integer "user_id"
    t.string "quarter"
    t.integer "ratings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_ratings_of_user_for_himselves_on_user_id"
  end

  create_table "review_dates", force: :cascade do |t|
    t.string "quarter"
    t.date "start_date"
    t.date "deadline_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_for_user_id"
    t.text "answer"
    t.string "quarter"
    t.string "user_current_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_for_user_id"], name: "index_reviews_on_question_for_user_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.string "name"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "f_name"
    t.string "l_name"
    t.date "dob"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "current_role"
    t.string "authentication_token", limit: 30
    t.integer "reporting_user_id"
    t.boolean "active_status", default: true
    t.date "doj"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "feedback_by_reporting_users", "users"
  add_foreign_key "feedback_by_reporting_users", "users", column: "feedback_for_user_id"
end
