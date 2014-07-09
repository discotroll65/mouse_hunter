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

ActiveRecord::Schema.define(version: 20140708141120) do

  create_table "bills", force: true do |t|
    t.string   "title"
    t.string   "issue"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "official_title"
    t.string   "url"
  end

  create_table "donors", force: true do |t|
    t.string   "name"
    t.string   "industry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lobbies", force: true do |t|
    t.integer  "politician_id"
    t.integer  "donor_id"
    t.integer  "money_given"
    t.string   "campaign_cycle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "politicians", force: true do |t|
    t.string   "name"
    t.string   "profile_pic"
    t.string   "district"
    t.string   "state"
    t.string   "party"
    t.integer  "voting_attendance"
    t.integer  "money_raised"
    t.integer  "efficiency"
    t.integer  "sponsorship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_form"
    t.string   "twitter_id"
    t.string   "in_office"
    t.string   "congress_cid"
    t.string   "chamber"
    t.string   "NYT_id"
    t.string   "url"
    t.string   "seniority"
    t.string   "next_election"
    t.string   "missed_votes_pct"
    t.string   "votes_with_party_pct"
    t.string   "facebook_account"
    t.string   "bioguide_id"
  end

  create_table "pvotes", force: true do |t|
    t.string   "name"
    t.string   "vote"
    t.integer  "bill_id"
    t.integer  "politician_id"
    t.integer  "round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsorships", force: true do |t|
    t.integer  "politician_id"
    t.integer  "bill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
