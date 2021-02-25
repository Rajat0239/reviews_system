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


ActiveRecord::Schema.define(version: 2021_02_22_102909) do

  create_table "answer_back_ups", force: :cascade do |t|
    t.integer "question_back_up_id"
    t.string "answer"
    t.string "feedback"
    t.string "quarter"
    t.string "f_name"
    t.string "l_name"
    t.string "email"
    t.string "dob"
    t.string "doj"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reporting_user_id"
    t.index ["question_back_up_id"], name: "index_answer_back_ups_on_question_back_up_id"
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

  create_table "question_back_ups", force: :cascade do |t|
    t.integer "question_id"
    t.string "question"
    t.string "question_type"
    t.string "option"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "question_for_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "question_id"
    t.string "quarter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
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
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "f_name"
    t.string "l_name"
    t.date "dob"
    t.datetime "doj"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token"
    t.string "current_role"
    t.integer "reporting_user_id"
    t.boolean "active_status", default: true
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "feedback_by_reporting_users", "users", column: "feedback_for_user_id"
end
