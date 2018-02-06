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

ActiveRecord::Schema.define(version: 20180206142918) do

  create_table "accuracy_test_cases", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "question_text"
    t.text "expected_text"
    t.boolean "is_expected_suggestion", default: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allowed_hosts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "scheme", default: 0
    t.string "domain", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheme", "domain", "bot_id"], name: "index_allowed_hosts_on_scheme_and_domain_and_bot_id", unique: true
  end

  create_table "allowed_ip_addresses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "value", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answer_files", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_type", null: false
    t.integer "file_size", default: 0
    t.integer "question_answer_id"
    t.index ["question_answer_id"], name: "index_answer_files_on_question_answer_id"
  end

  create_table "answer_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "decision_branch_id", null: false
    t.integer "answer_record_id", null: false
    t.string "answer_record_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decision_branch_id", "answer_record_id", "answer_record_type"], name: "answer_links_main_index", unique: true
  end

  create_table "bad_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "message_id", null: false
    t.text "body"
    t.integer "guest_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_chatwork_credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "api_token", null: false
    t.string "webhook_token", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_line_credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "channel_id", null: false
    t.string "channel_secret", null: false
    t.string "channel_access_token", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_microsoft_credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "app_id", null: false
    t.string "app_password", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bots", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "name"
    t.string "token", limit: 64, null: false
    t.string "classify_failed_message"
    t.string "start_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "learning_status"
    t.datetime "learning_status_changed_at"
    t.text "selected_question_answer_ids"
    t.text "has_suggests_message"
    t.boolean "enable_guest_user_registration", default: false
    t.string "widget_subtitle"
    t.text "chat_test_results", limit: 16777215
    t.boolean "is_chat_test_processing"
    t.boolean "demo"
    t.index ["user_id"], name: "index_bots_on_user_id"
  end

  create_table "chat_service_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id", null: false
    t.integer "service_type", default: 0, null: false
    t.string "uid", null: false
    t.string "name"
    t.string "guest_key", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id", "service_type", "uid"], name: "index_chat_service_users_on_bot_id_and_service_type_and_uid", unique: true
  end

  create_table "chats", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "guest_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bot_id", null: false
    t.boolean "is_staff", default: false
    t.boolean "is_normal", default: false, null: false
    t.index ["guest_key"], name: "index_chats_on_guest_key"
    t.index ["is_normal"], name: "index_chats_on_is_normal"
    t.index ["is_staff"], name: "index_chats_on_is_staff"
  end

  create_table "decision_branches", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bot_id", null: false
    t.integer "question_answer_id"
    t.text "answer"
    t.integer "parent_decision_branch_id"
    t.index ["bot_id"], name: "index_decision_branches_on_bot_id"
    t.index ["question_answer_id", "parent_decision_branch_id"], name: "main_decision_branches_index"
  end

  create_table "delayed_jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dumps", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id", null: false
    t.string "name", null: false
    t.binary "content", limit: 4294967295
  end

  create_table "exports", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file", null: false
    t.integer "bot_id", null: false
    t.integer "encoding", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_exports_on_bot_id"
  end

  create_table "guest_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "email"
    t.string "guest_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_key"], name: "index_guest_users_on_guest_key"
  end

  create_table "learning_parameters", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id"
    t.integer "algorithm", default: 0, null: false
    t.json "parameters"
    t.integer "feedback_algorithm", default: 0, null: false
    t.json "parameters_for_feedback"
    t.float "classify_threshold", limit: 24, default: 0.5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "similar_question_answers_threshold", limit: 24
    t.index ["bot_id"], name: "index_learning_parameters_on_bot_id"
  end

  create_table "learning_training_messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id"
    t.text "question"
    t.text "answer_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_answer_id"
    t.boolean "is_sub_question", default: false
    t.index ["bot_id"], name: "index_learning_training_messages_on_bot_id"
    t.index ["question_answer_id"], name: "index_learning_training_messages_on_question_answer_id"
  end

  create_table "messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "chat_id"
    t.string "speaker", null: false
    t.text "body"
    t.string "user_agent", limit: 1024
    t.boolean "answer_failed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "answer_marked", default: false, null: false
    t.integer "question_answer_id"
    t.text "similar_question_answers_log"
    t.integer "decision_branch_id"
    t.boolean "is_show_similar_question_answers", default: true
    t.json "reply_log"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["question_answer_id"], name: "index_messages_on_question_answer_id"
  end

  create_table "organization_bot_ownerships", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "organization_id", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "bot_id"], name: "main_organization_bot_ownership_index", unique: true
  end

  create_table "organization_user_memberships", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "organization_id"], name: "main_organization_user_membership_index", unique: true
  end

  create_table "organizations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "image"
    t.text "description"
    t.integer "plan", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "trial_finished_at"
  end

  create_table "question_answers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id"
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "answer"
    t.index ["bot_id"], name: "index_question_answers_on_bot_id"
  end

  create_table "ratings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "level", null: false
    t.integer "message_id", null: false
    t.integer "question_answer_id"
    t.integer "bot_id", null: false
    t.text "question", null: false
    t.text "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id", null: false
    t.float "accuracy", limit: 24
    t.float "precision", limit: 24
    t.float "recall", limit: 24
    t.float "f1", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_scores_on_bot_id"
  end

  create_table "sentence_synonyms", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "created_user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_answer_id"
    t.index ["created_user_id"], name: "index_sentence_synonyms_on_created_user_id"
    t.index ["question_answer_id"], name: "index_sentence_synonyms_on_question_answer_id"
  end

  create_table "sub_questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "question_answer_id", null: false
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "guest_message"
    t.text "bot_message"
    t.boolean "is_done", default: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bot_message_id"
    t.integer "guest_message_id"
  end

  create_table "topic_taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "question_answer_id", null: false
    t.integer "topic_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_answer_id", "topic_tag_id"], name: "index_topic_taggings_on_question_answer_id_and_topic_tag_id", unique: true
  end

  create_table "topic_tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.integer "bot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_show_in_suggestion", default: true
    t.index ["name", "bot_id"], name: "index_topic_tags_on_name_and_bot_id", unique: true
  end

  create_table "tutorials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bot_id", null: false
    t.boolean "edit_bot_profile", default: false, null: false
    t.boolean "fifty_question_answers", default: false, null: false
    t.boolean "ask_question", default: false, null: false
    t.boolean "embed_chat", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role", default: 0, null: false
    t.json "notification_settings"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "word_mapping_synonyms", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "value", null: false
    t.integer "word_mapping_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "word_mappings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "word", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bot_id"
    t.index ["bot_id"], name: "index_word_mappings_on_bot_id"
  end

end
