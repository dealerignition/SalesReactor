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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120228161852) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "contact_type"
    t.string   "title"
    t.string   "email"
    t.integer  "has_contacts_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "has_contacts_type"
  end

  create_table "phones", :force => true do |t|
    t.string   "phone_type"
    t.string   "number"
    t.integer  "has_phones_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "has_phones_type"
  end

  create_table "programs", :force => true do |t|
    t.integer  "company_id"
    t.string   "program_type"
    t.text     "products"
    t.text     "trademarks"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

end
