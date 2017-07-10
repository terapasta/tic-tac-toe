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

ActiveRecord::Schema.define(version: 20170710063046) do

  create_table "accuracy_test_cases", force: :cascade do |t|
    t.text     "question_text",          limit: 65535
    t.text     "expected_text",          limit: 65535
    t.boolean  "is_expected_suggestion",               default: false
    t.integer  "bot_id",                 limit: 4,                     null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "allowed_hosts", force: :cascade do |t|
    t.integer  "scheme",     limit: 4,   default: 0
    t.string   "domain",     limit: 255,             null: false
    t.integer  "bot_id",     limit: 4,               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "allowed_hosts", ["scheme", "domain", "bot_id"], name: "index_allowed_hosts_on_scheme_and_domain_and_bot_id", unique: true, using: :btree

  create_table "answer_files", force: :cascade do |t|
    t.integer  "answer_id",  limit: 4,               null: false
    t.string   "file",       limit: 255,             null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "file_type",  limit: 255,             null: false
    t.integer  "file_size",  limit: 4,   default: 0
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "defined_answer_id", limit: 4
    t.string   "context",           limit: 255,   default: "0", null: false
    t.text     "body",              limit: 65535
    t.string   "transition_to",     limit: 255
    t.string   "type",              limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "bot_id",            limit: 4
  end

  add_index "answers", ["context"], name: "index_answers_on_context", using: :btree
  add_index "answers", ["defined_answer_id"], name: "index_answers_on_defined_answer_id", unique: true, using: :btree

  create_table "auto_tweets", force: :cascade do |t|
    t.string   "body",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "bots", force: :cascade do |t|
    t.integer  "user_id",                      limit: 4
    t.string   "name",                         limit: 255
    t.string   "token",                        limit: 64,                    null: false
    t.string   "classify_failed_message",      limit: 255
    t.string   "start_message",                limit: 255
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "image",                        limit: 255
    t.string   "learning_status",              limit: 255
    t.datetime "learning_status_changed_at"
    t.boolean  "is_limited",                                 default: false
    t.boolean  "is_selected_for_chat",                       default: false
    t.text     "selected_question_answer_ids", limit: 65535
  end

  add_index "bots", ["user_id"], name: "index_bots_on_user_id", using: :btree

  create_table "chats", force: :cascade do |t|
    t.string   "context",    limit: 255
    t.string   "guest_key",  limit: 255,                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "bot_id",     limit: 4,                   null: false
    t.boolean  "is_staff",               default: false
    t.boolean  "is_normal",              default: false, null: false
  end

  add_index "chats", ["is_normal"], name: "index_chats_on_is_normal", using: :btree
  add_index "chats", ["is_staff"], name: "index_chats_on_is_staff", using: :btree

  create_table "contact_answers", force: :cascade do |t|
    t.text     "body",          limit: 65535
    t.string   "transition_to", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "bot_id",        limit: 4,     null: false
  end

  create_table "contact_states", force: :cascade do |t|
    t.integer  "chat_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "contact_states", ["chat_id"], name: "index_contact_states_on_chat_id", using: :btree

  create_table "contexts", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "decision_branches", force: :cascade do |t|
    t.integer  "answer_id",      limit: 4,                null: false
    t.string   "body",           limit: 255, default: "", null: false
    t.integer  "next_answer_id", limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "bot_id",         limit: 4,                null: false
  end

  add_index "decision_branches", ["answer_id"], name: "index_decision_branches_on_answer_id", using: :btree
  add_index "decision_branches", ["bot_id"], name: "index_decision_branches_on_bot_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exports", force: :cascade do |t|
    t.string   "file",       limit: 255, null: false
    t.integer  "bot_id",     limit: 4,   null: false
    t.integer  "encoding",   limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "exports", ["bot_id"], name: "index_exports_on_bot_id", using: :btree

  create_table "favorite_words", force: :cascade do |t|
    t.string   "word",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "bot_id",     limit: 4,   null: false
  end

  create_table "learning_parameters", force: :cascade do |t|
    t.integer  "bot_id",                        limit: 4
    t.integer  "algorithm",                     limit: 4,     default: 0,     null: false
    t.text     "params_for_algorithm",          limit: 65535
    t.boolean  "include_failed_data",                         default: false, null: false
    t.boolean  "include_tag_vector",                          default: false, null: false
    t.float    "classify_threshold",            limit: 24,    default: 0.5,   null: false
    t.boolean  "use_similarity_classification",               default: true,  null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "learning_parameters", ["bot_id"], name: "index_learning_parameters_on_bot_id", using: :btree

  create_table "learning_training_messages", force: :cascade do |t|
    t.integer  "bot_id",             limit: 4
    t.string   "question",           limit: 255
    t.text     "answer_body",        limit: 65535
    t.integer  "answer_id",          limit: 4
    t.text     "tag_ids",            limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "question_answer_id", limit: 4
  end

  add_index "learning_training_messages", ["answer_id"], name: "index_learning_training_messages_on_answer_id", using: :btree
  add_index "learning_training_messages", ["bot_id"], name: "index_learning_training_messages_on_bot_id", using: :btree
  add_index "learning_training_messages", ["question_answer_id"], name: "index_learning_training_messages_on_question_answer_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "chat_id",       limit: 4
    t.integer  "answer_id",     limit: 4
    t.string   "speaker",       limit: 255,                   null: false
    t.text     "body",          limit: 65535
    t.string   "user_agent",    limit: 1024
    t.boolean  "learn_enabled",               default: true,  null: false
    t.boolean  "answer_failed",               default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "rating",        limit: 4,     default: 0
    t.boolean  "answer_marked",               default: false, null: false
    t.datetime "trained_at"
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id", using: :btree
  add_index "messages", ["rating"], name: "index_messages_on_rating", using: :btree
  add_index "messages", ["trained_at"], name: "index_messages_on_trained_at", using: :btree

  create_table "question_answers", force: :cascade do |t|
    t.integer  "bot_id",     limit: 4
    t.text     "question",   limit: 65535
    t.integer  "answer_id",  limit: 4
    t.text     "underlayer", limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "selection",                default: false
  end

  add_index "question_answers", ["answer_id"], name: "index_question_answers_on_answer_id", using: :btree
  add_index "question_answers", ["bot_id"], name: "index_question_answers_on_bot_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "bot_id",     limit: 4,  null: false
    t.float    "accuracy",   limit: 24
    t.float    "precision",  limit: 24
    t.float    "recall",     limit: 24
    t.float    "f1",         limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "scores", ["bot_id"], name: "index_scores_on_bot_id", using: :btree

  create_table "sentence_synonyms", force: :cascade do |t|
    t.integer  "created_user_id",    limit: 4,     null: false
    t.text     "body",               limit: 65535, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "question_answer_id", limit: 4
  end

  add_index "sentence_synonyms", ["created_user_id"], name: "index_sentence_synonyms_on_created_user_id", using: :btree
  add_index "sentence_synonyms", ["question_answer_id"], name: "index_sentence_synonyms_on_question_answer_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.integer  "feature",    limit: 4, null: false
    t.boolean  "enabled",              null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "bot_id",     limit: 4, null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.text     "guest_message", limit: 65535
    t.text     "bot_message",   limit: 65535
    t.boolean  "is_done",                     default: false
    t.integer  "bot_id",        limit: 4,                     null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "topic_taggings", force: :cascade do |t|
    t.integer  "question_answer_id", limit: 4, null: false
    t.integer  "topic_tag_id",       limit: 4, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "topic_taggings", ["question_answer_id", "topic_tag_id"], name: "index_topic_taggings_on_question_answer_id_and_topic_tag_id", unique: true, using: :btree

  create_table "topic_tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "bot_id",     limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "topic_tags", ["name", "bot_id"], name: "index_topic_tags_on_name_and_bot_id", unique: true, using: :btree

  create_table "training_texts", force: :cascade do |t|
    t.text     "body",       limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "twitter_replies", force: :cascade do |t|
    t.integer  "tweet_id",    limit: 8,   null: false
    t.string   "screen_name", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "bot_id",      limit: 4,   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   limit: 4,   default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_mappings", force: :cascade do |t|
    t.string   "word",       limit: 20, null: false
    t.string   "synonym",    limit: 20, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "bot_id",     limit: 4
  end

  add_index "word_mappings", ["bot_id"], name: "index_word_mappings_on_bot_id", using: :btree

end
