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

ActiveRecord::Schema.define(:version => 20130618173523) do

  create_table "amenities", :force => true do |t|
    t.string   "description",                :default => "",    :null => false
    t.integer  "rank",                       :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_vaultware",             :default => false, :null => false
    t.boolean  "from_propertysolutions",     :default => false
    t.boolean  "use_propertysolutions_data", :default => false
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
  end

  add_index "amenities", ["description"], :name => "index_amenities_on_description"

  create_table "amenities_floorplans", :id => false, :force => true do |t|
    t.integer "amenity_id"
    t.integer "floorplan_id"
  end

  add_index "amenities_floorplans", ["amenity_id"], :name => "index_amenities_floorplans_on_amenity_id"
  add_index "amenities_floorplans", ["floorplan_id"], :name => "index_amenities_floorplans_on_floorplan_id"

  create_table "amenities_properties", :id => false, :force => true do |t|
    t.integer "amenity_id"
    t.integer "property_id"
  end

  add_index "amenities_properties", ["amenity_id"], :name => "index_amenities_properties_on_amenity_id"
  add_index "amenities_properties", ["property_id"], :name => "index_amenities_properties_on_property_id"

  create_table "amenities_units", :id => false, :force => true do |t|
    t.integer "amenity_id"
    t.integer "unit_id"
  end

  add_index "amenities_units", ["amenity_id"], :name => "index_amenities_units_on_amenity_id"
  add_index "amenities_units", ["unit_id"], :name => "index_amenities_units_on_unit_id"

  create_table "associates", :force => true do |t|
    t.string   "name",        :default => "",                   :null => false
    t.string   "title",       :default => "",                   :null => false
    t.text     "description"
    t.string   "image",       :default => "",                   :null => false
    t.text     "story"
    t.text     "work"
    t.text     "career_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",        :default => "CommunityAssociate"
    t.boolean  "featured",    :default => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "executives", :force => true do |t|
    t.string   "name",           :default => "",                :null => false
    t.string   "title",          :default => "",                :null => false
    t.text     "office_address"
    t.string   "phone",          :default => ""
    t.string   "email",          :default => ""
    t.text     "bio"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",       :default => "Company Officer", :null => false
    t.integer  "position",       :default => 0,                 :null => false
  end

  create_table "floorplans", :force => true do |t|
    t.decimal  "bedrooms_count",             :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "bathrooms_count",            :precision => 3,  :scale => 1, :default => 0.0,   :null => false
    t.string   "name",                                                      :default => "",    :null => false
    t.integer  "area_min",                                                  :default => 0,     :null => false
    t.integer  "area_max",                                                  :default => 0
    t.string   "gables_id",                                                 :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.boolean  "from_vaultware",                                            :default => false, :null => false
    t.text     "availability_url",                                                             :null => false
    t.decimal  "rent_min",                   :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "rent_max",                   :precision => 10, :scale => 0, :default => 0,     :null => false
    t.boolean  "from_propertysolutions",                                    :default => false
    t.boolean  "use_propertysolutions_data",                                :default => false
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
  end

  add_index "floorplans", ["gables_id"], :name => "index_floorplans_on_gables_id", :unique => true
  add_index "floorplans", ["property_id"], :name => "index_floorplans_on_property_id"

  create_table "gca_promos", :force => true do |t|
    t.string   "heading",    :default => "", :null => false
    t.text     "text"
    t.string   "link"
    t.string   "image"
    t.integer  "position",   :default => 0,  :null => false
    t.string   "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gca_property_regions", :force => true do |t|
    t.integer  "property_id"
    t.integer  "region_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gca_regions", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "green_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "green_initiatives", :force => true do |t|
    t.string   "name"
    t.integer  "green_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "green_initiatives_properties", :id => false, :force => true do |t|
    t.integer  "green_initiative_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_slides", :force => true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    :default => 0,           :null => false
    t.string   "title",       :default => "",          :null => false
    t.string   "subtitle",    :default => ""
    t.text     "description"
    t.string   "type",        :default => "HomeSlide"
  end

  create_table "images", :force => true do |t|
    t.boolean  "from_vaultware",             :default => false, :null => false
    t.string   "vaultware_url",              :default => "",    :null => false
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                   :default => 0,     :null => false
    t.string   "name"
    t.string   "description"
    t.boolean  "from_propertysolutions",     :default => false
    t.string   "propertysolutions_url"
    t.boolean  "use_propertysolutions_data", :default => false
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
  end

  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"

  create_table "life_slides", :force => true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 0, :null => false
  end

  create_table "page_blocks", :force => true do |t|
    t.boolean  "editable",   :default => true,      :null => false
    t.string   "title",      :default => "",        :null => false
    t.text     "content",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "partial",    :default => "default", :null => false
    t.string   "type",       :default => "Block"
  end

  create_table "page_main_blocks", :force => true do |t|
    t.integer  "position",      :default => 0, :null => false
    t.integer  "page_id"
    t.integer  "page_block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_main_blocks", ["page_id", "page_block_id"], :name => "index_page_main_blocks_on_page_id_and_block_id"

  create_table "page_side_blocks", :force => true do |t|
    t.integer  "position",      :default => 0, :null => false
    t.integer  "page_id"
    t.integer  "page_block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_side_blocks", ["page_id", "page_block_id"], :name => "index_page_side_blocks_on_page_id_and_block_id"

  create_table "pages", :force => true do |t|
    t.boolean  "published",   :default => true, :null => false
    t.string   "path",        :default => "",   :null => false
    t.string   "subtitle",    :default => ""
    t.string   "title",       :default => "",   :null => false
    t.string   "name",        :default => "",   :null => false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "show_in_nav", :default => true, :null => false
    t.integer  "position",    :default => 0,    :null => false
    t.text     "description"
  end

  create_table "posts", :force => true do |t|
    t.string   "kind",         :default => "NewsItem", :null => false
    t.text     "summary",                              :null => false
    t.text     "text",                                 :null => false
    t.string   "title",        :default => "",         :null => false
    t.boolean  "featured",     :default => false,      :null => false
    t.date     "published_at",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "published",    :default => false,      :null => false
  end

  create_table "promos", :force => true do |t|
    t.string   "heading",    :default => "", :null => false
    t.text     "text"
    t.string   "link"
    t.string   "image"
    t.integer  "position",   :default => 0,  :null => false
    t.string   "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", :force => true do |t|
    t.boolean  "allows_dogs",                  :default => false, :null => false
    t.boolean  "allows_cats",                  :default => false, :null => false
    t.text     "short_description",                               :null => false
    t.text     "long_description",                                :null => false
    t.string   "name",                         :default => "",    :null => false
    t.string   "phone",                        :default => "",    :null => false
    t.string   "street",                       :default => "",    :null => false
    t.string   "city",                         :default => "",    :null => false
    t.string   "state",                        :default => "",    :null => false
    t.string   "zip",                          :default => "",    :null => false
    t.boolean  "from_vaultware",               :default => false, :null => false
    t.string   "gables_id",                    :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",                     :default => 0.0,   :null => false
    t.float    "longitude",                    :default => 0.0,   :null => false
    t.integer  "region_id"
    t.boolean  "published",                    :default => true,  :null => false
    t.string   "yelp_id"
    t.string   "video_id"
    t.string   "contact_form_email"
    t.text     "blog_url"
    t.text     "facebook_url"
    t.text     "twitter_url"
    t.boolean  "show_walkscore",               :default => true,  :null => false
    t.boolean  "show_ratings",                 :default => true,  :null => false
    t.text     "community_programs"
    t.string   "monday_hours",                 :default => "",    :null => false
    t.string   "tuesday_hours",                :default => "",    :null => false
    t.string   "wednesday_hours",              :default => "",    :null => false
    t.string   "thursday_hours",               :default => "",    :null => false
    t.string   "friday_hours",                 :default => "",    :null => false
    t.string   "saturday_hours",               :default => "",    :null => false
    t.string   "sunday_hours",                 :default => "",    :null => false
    t.boolean  "uses_chat",                    :default => false, :null => false
    t.string   "full_brochure"
    t.string   "short_brochure"
    t.text     "dog_policy"
    t.text     "cat_policy"
    t.text     "calendar_url"
    t.text     "pet_policy"
    t.boolean  "featured",                     :default => false
    t.string   "path",                         :default => "",    :null => false
    t.string   "testimonial_video"
    t.string   "address2"
    t.text     "shopping_and_dining"
    t.integer  "insite_id"
    t.text     "building_specifications"
    t.string   "building_specifications_file"
    t.string   "sor_policy"
    t.string   "lease_briefs"
    t.string   "resident_brochure"
    t.string   "google_id"
    t.text     "google_place_data"
    t.string   "pinterest_url"
    t.string   "resident_reviews_id"
    t.string   "retail_link"
    t.boolean  "from_propertysolutions",       :default => false
    t.boolean  "use_propertysolutions_data",   :default => false
    t.string   "availability_url"
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
    t.string   "website"
  end

  add_index "properties", ["gables_id"], :name => "index_properties_on_gables_id", :unique => true
  add_index "properties", ["insite_id"], :name => "index_properties_on_insite_id"

  create_table "properties_seo_regions", :id => false, :force => true do |t|
    t.integer "property_id"
    t.integer "seo_region_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "regions", :force => true do |t|
    t.string   "name",        :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",    :default => 0.0,   :null => false
    t.float    "longitude",   :default => 0.0,   :null => false
    t.text     "description",                    :null => false
    t.boolean  "for_seo",     :default => false, :null => false
  end

  add_index "regions", ["name"], :name => "index_regions_on_name", :unique => true

  create_table "search_amenities", :force => true do |t|
    t.string   "description", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "seo_regions", :force => true do |t|
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string "key"
    t.string "value"
  end

  add_index "settings", ["key"], :name => "index_settings_on_key"

  create_table "site_plans", :force => true do |t|
    t.string  "image"
    t.integer "property_id"
    t.text    "image_map"
  end

  create_table "specials", :force => true do |t|
    t.text     "header",                                        :null => false
    t.text     "body",                                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_vaultware",             :default => false, :null => false
    t.integer  "specialable_id"
    t.string   "specialable_type"
    t.boolean  "from_propertysolutions",     :default => false
    t.boolean  "use_propertysolutions_data", :default => false
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
  end

  create_table "tablet_guests", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.string   "email"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "employer_name"
    t.string   "employer_address_line1"
    t.string   "employer_address_line2"
    t.string   "employer_zip"
    t.string   "referral_name"
    t.string   "referral_fee"
    t.boolean  "escorted"
    t.datetime "move_in_date"
    t.string   "preferred_unit_type1"
    t.string   "preferred_unit_type2"
    t.integer  "num_occupants"
    t.text     "notes"
    t.text     "apartment_needs"
    t.boolean  "pets"
    t.boolean  "furnished"
    t.integer  "tablet_rent_range_id"
    t.integer  "tablet_leasing_reason_id"
    t.integer  "tablet_not_leasing_reason_id"
    t.integer  "tablet_lead_source_id"
    t.integer  "tablet_property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tablet_insite_user_id"
    t.string   "property_name"
    t.integer  "insite_id"
    t.string   "status"
    t.boolean  "inactive"
    t.text     "guest_names"
    t.boolean  "add_prospect_complete"
    t.boolean  "select_apartments_complete"
    t.boolean  "gather_licenses_complete"
    t.boolean  "gables_difference_complete"
    t.boolean  "return_licenses_complete"
    t.boolean  "take_homes_complete"
    t.boolean  "notes_complete"
    t.boolean  "thank_you_note_complete"
    t.boolean  "invite_to_apply_complete"
    t.text     "preferred_floorplans"
    t.text     "notes_likes"
    t.text     "notes_dislikes"
    t.text     "notes_remarks"
    t.text     "notes_hotbuttons"
    t.boolean  "community_brochure"
    t.boolean  "floorplan_brochure"
    t.boolean  "building_specifications"
    t.boolean  "follow_up_required"
    t.date     "follow_up_date"
    t.text     "not_leasing_reason_details"
    t.boolean  "email_optin"
    t.integer  "max_rent"
    t.integer  "guest_card_id"
    t.integer  "unit_id"
    t.boolean  "referrer_disabled"
  end

  create_table "tablet_insite_users", :force => true do |t|
    t.string "user_id"
    t.string "name"
    t.string "email"
  end

  create_table "tablet_lead_sources", :id => false, :force => true do |t|
    t.integer "id"
    t.integer "tablet_property_id"
    t.string  "name"
  end

  add_index "tablet_lead_sources", ["tablet_property_id", "id"], :name => "index_tablet_lead_sources_on_tablet_property_id_and_id", :unique => true

  create_table "tablet_leasing_reasons", :force => true do |t|
    t.string "name"
  end

  create_table "tablet_not_leasing_reasons", :force => true do |t|
    t.string "name"
  end

  create_table "tablet_properties", :force => true do |t|
    t.string  "name"
    t.integer "vaultware_id"
    t.string  "community_manager"
    t.string  "community_manager_email"
    t.string  "regional_manager"
    t.string  "regional_manager_email"
    t.string  "state"
    t.string  "phone"
  end

  create_table "tablet_rent_ranges", :force => true do |t|
    t.string "name"
  end

  create_table "units", :force => true do |t|
    t.string   "type",                                                      :default => "",           :null => false
    t.boolean  "occupied",                                                  :default => true,         :null => false
    t.string   "name",                                                      :default => "",           :null => false
    t.decimal  "rent_min",                   :precision => 10, :scale => 0, :default => 0,            :null => false
    t.decimal  "rent_max",                   :precision => 10, :scale => 0, :default => 0,            :null => false
    t.integer  "entry_floor",                                               :default => 0,            :null => false
    t.integer  "area_min",                                                  :default => 0,            :null => false
    t.integer  "area_max",                                                  :default => 0
    t.string   "gables_id",                                                 :default => "",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "floorplan_id"
    t.boolean  "from_vaultware",                                            :default => false,        :null => false
    t.string   "building_name",                                             :default => "",           :null => false
    t.text     "availability_url",                                                                    :null => false
    t.date     "available_on",                                              :default => '2011-01-01', :null => false
    t.boolean  "from_propertysolutions",                                    :default => false
    t.boolean  "use_propertysolutions_data",                                :default => false
    t.text     "propertysolutions_data"
    t.text     "vaultware_data"
  end

  add_index "units", ["floorplan_id"], :name => "index_units_on_floorplan_id"
  add_index "units", ["gables_id"], :name => "index_units_on_gables_id", :unique => true

  create_table "urban_images", :force => true do |t|
    t.string   "image"
    t.integer  "property_id"
    t.integer  "position",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urban_promos", :force => true do |t|
    t.string   "heading",    :default => "", :null => false
    t.text     "text"
    t.string   "link"
    t.string   "image"
    t.integer  "position",   :default => 0,  :null => false
    t.string   "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urban_properties", :force => true do |t|
    t.text     "short_description"
    t.text     "long_description"
    t.text     "shopping_etc"
    t.integer  "opening_year",      :default => 0
    t.integer  "apartments_count",  :default => 0
    t.integer  "square_footage",    :default => 0
    t.text     "site_url"
    t.text     "map_url"
    t.string   "name",              :default => "", :null => false
    t.string   "phone",             :default => "", :null => false
    t.string   "street",            :default => "", :null => false
    t.string   "city",              :default => "", :null => false
    t.string   "state",             :default => "", :null => false
    t.string   "zip",               :default => "", :null => false
    t.string   "email",             :default => "", :null => false
    t.string   "full_brochure"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "property_id"
  end

  create_table "user_searches", :force => true do |t|
    t.string   "query"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                     :null => false
    t.string   "encrypted_password",      :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "administers_residential",                :default => false, :null => false
    t.boolean  "administers_gca",                        :default => false, :null => false
    t.boolean  "administers_urban",                      :default => false, :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
