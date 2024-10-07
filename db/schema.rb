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

ActiveRecord::Schema[7.1].define(version: 2024_09_24_000812) do
  create_table "contracts", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "freelancer_id"
    t.integer "client_id"
    t.text "content"
    t.string "status"
    t.string "docusign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "revisions"
    t.boolean "client_signed"
    t.boolean "contractor_signed"
    t.index ["project_id"], name: "index_contracts_on_project_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "user_id"
    t.string "recipient_email"
    t.string "status", default: "pending"
    t.integer "project_id"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_invitations_on_project_id"
    t.index ["recipient_email"], name: "index_invitations_on_recipient_email", unique: true
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "deadline"
    t.decimal "escrow_amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_payment_intent_id"
    t.string "braintree_transaction_id"
    t.string "escrow_status", default: "pending"
    t.index ["project_id"], name: "index_milestones_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "freelancer_id"
    t.integer "client_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_questionnaires_on_project_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "questionnaire_id", null: false
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question_type"
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "stripe_customer_id"
    t.string "stripe_card_id"
    t.string "connected_account_id"
    t.string "payment_method_id"
    t.string "braintree_customer_id"
    t.string "braintree_payment_method_nonce"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.integer "contract_id", null: false
    t.integer "version_number", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_versions_on_contract_id"
  end

  add_foreign_key "contracts", "projects"
  add_foreign_key "invitations", "users"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "milestones", "projects"
  add_foreign_key "questionnaires", "projects"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "versions", "contracts"
end
