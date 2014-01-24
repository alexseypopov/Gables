class Property < ActiveRecord::Base
  belongs_to :region
  has_one   :urban_property, :class_name => "Urban::Property"
  has_one   :tablet_property, class_name: 'Tablet::Property', primary_key: 'gables_id', foreign_key: 'vaultware_id'
  has_many  :floorplans
  has_many  :specials,:dependent => :destroy, :as => :specialable
  has_many  :images,  :dependent => :destroy, :as => :imageable,
                      :order => "images.position ASC"
  has_many  :site_plans
  has_many  :units, :through => :floorplans
  has_and_belongs_to_many :amenities
  has_and_belongs_to_many :seo_regions
  has_and_belongs_to_many :green_initiatives
  before_save :assign_coordinates
  mount_uploader :full_brochure,  BrochureUploader
  mount_uploader :short_brochure, BrochureUploader
  mount_uploader :building_specifications_file,  BrochureUploader
  mount_uploader :lease_briefs, BrochureUploader
  mount_uploader :resident_brochure, BrochureUploader
  geocoded_by :address
  serialize :google_place_data, Hash

  include HasAmenity
  include SetGablesId
  include DataSourceSwitch
  before_create :set_gables_id

  validates_non_nilness_of  :short_description, :long_description, :name, :phone,
                            :street, :city, :zip, :gables_id, :state,
                            :monday_hours, :tuesday_hours, :wednesday_hours, :thursday_hours,
                            :friday_hours, :saturday_hours, :sunday_hours, :uses_chat, :path
  validates :floorplans,  :vaultware_exclusivity => true, :propertysolutions_exclusivity => true
  validates :specials,    :vaultware_exclusivity => true, :propertysolutions_exclusivity => true
  validates :amenities,   :vaultware_exclusivity => true, :propertysolutions_exclusivity => true

  attr_accessible :published, :featured, :name, :pet_policy, :allows_dogs, :dog_policy, :allows_cats, :cat_policy,
                  :short_description, :long_description, :images, :phone, :street, :city, :state, :zip,
                  :monday_hours, :tuesday_hours, :wednesday_hours, :thursday_hours, :friday_hours, :saturday_hours, :sunday_hours,
                  :region, :floorplans, :specials, :amenities, :show_walkscore, :show_ratings, :contact_form_email,
                  :yelp_id, :google_id, :video_id, :testimonial_video, :blog_url, :calendar_url, :facebook_url, :twitter_url,
                  :pinterest_url, :green_initiatives, :community_programs, :shopping_and_dining, :uses_chat, :full_brochure,
                  :short_brochure, :resident_brochure, :building_specifications, :building_specifications_file, :lease_briefs,
                  :sor_policy, :path, :urban_property, :resident_reviews_id, :region_id, :green_initiative_ids, :amenity_ids,
                  :special_ids, :floorplan_ids, :image_ids, :from_vaultware, :gables_id, :insite_id, :use_propertysolutions_data,
                  :full_brochure_cache, :short_brochure_cache, :building_specifications_file_cache, :lease_briefs_cache, :resident_brochure_cache, :from_propertysolutions, :propertysolutions_data, :vaultware_data


  VaultwareColumns = [
    "from_vaultware",
    "name",
    "gables_id",
    "insite_id",
    "allows_dogs",
    "dog_policy",
    "allows_cats",
    "cat_policy",
    "short_description",
    "long_description",
    "phone",
    "street",
    "city",
    "state",
    "zip",
    "monday_hours",
    "tuesday_hours",
    "wednesday_hours",
    "thursday_hours",
    "friday_hours",
    "saturday_hours",
    "sunday_hours",
    "pet_policy",
    "contact_form_email"
  ]

  PropertysolutionsColumns = [
      'pet_policy',
      'long_description',
      'short_description',
      'name',
      'gables_id',
      'phone',
      'street',
      'city',
      'state',
      'zip',
      'contact_form_email',
      'monday_hours',
      'tuesday_hours',
      'wednesday_hours',
      'thursday_hours',
      'friday_hours',
      'saturday_hours',
      'sunday_hours',
      'availability_url',
      'published'
  ]

  def image_ids=(ids)
    is = []

    ids.each_with_index do |id, index|
      image = nil

      begin
        image = Image.find(id)
      rescue ActiveRecord::RecordNotFound
        next
      end

      image.update_attributes!(:position => index)
      is << image
    end

    update_attributes(:images => is)
  end

  def state_enum
    Carmen::state_codes('US')
  end

  def self.published
    where(:published => true)
  end

  def self.without_region
    where(:region_id => nil)
  end

  def address
    "#{street}, #{city}, #{state} #{zip}"
  end

  def active_special
    specials = self.specials
    active_special = nil
    if(specials.length > 1)
      active_special = specials.where(:body => '').first
    else
      active_special = specials.first
    end
    active_special
  end

  # search : Search
  # N.B. floorplan can't be available if it doesn't have units
  # => [Floorplan]
  def available_floorplans(search=nil)
    @available_floorplans ||= begin
      if search
        search.floorplans_for(self).joins(:units).where("units.rent_min > 0")
      else
        self.floorplans.joins(:units).
          where("units.rent_min > 0").
          order('name','bedrooms_count, bathrooms_count').
          group("floorplans.id")
      end
    end
  end

  # search : Search
  # => [Floorplan]
  def unavailable_floorplans(search=nil)
    @unavailable_floorplans ||= begin
      if search
        search.floorplans_for(self)
      else
        self.floorplans.order('bedrooms_count, bathrooms_count').group("floorplans.id") - available_floorplans(search)
      end
    end
  end

  def to_param
    "#{id}-#{name.to_url}-#{city.to_url}-#{state.to_url}"
  end

  # Groups consecutive office hours whose hours are the same
  def grouped_office_hours
    merged_hours.map { |hash_list|
      days = if hash_list.length == 1
        hash_list.first[:day]
      elsif hash_list.length > 1
        "#{hash_list.first[:day]} - #{hash_list.last[:day]}"
      end
      {:hours => hash_list.first[:hours],
       :day   => days }
    }.delete_if {|hash| hash[:hours].blank? }
  end

  def fetch_google_place_data
    place = GooglePlace.search({
      location: "#{latitude},#{longitude}",
      sensor:   "false",
      types:    'establishment',
      rankby:   "distance"
    })['results'].select{|r| r['name'] == name}.first
    
    update_attribute :google_place_data, GooglePlace.details({
      reference: place['reference'],
      sensor: 'false'
    })['result'] if place
  end

  def search_google_place_data
    search = GooglePlace.search({
      location: "#{latitude},#{longitude}",
      sensor:   "false",
      types:    'establishment',
      rankby:   "distance"
    })['results']
  end

  def rating
    if google_place_data
      return google_place_data['rating'] if google_place_data['rating']
      if google_place_data['reviews']
        google_place_data['rating'] = begin
          google_place_data['reviews'].map{|x|
            x['aspects']
          }.map{|x|x.first['rating']}.inject(0.0){|sum, el|
           sum + el
          } / google_place_data['reviews'].size
        end
        save
      end
      google_place_data['rating']
    end
  end

private
  def merged_hours
    day_of_week = {0 => 'Monday',
                   1 => 'Tuesday',
                   2 => 'Wednesday',
                   3 => 'Thursday',
                   4 => 'Friday',
                   5 => 'Saturday',
                   6 => 'Sunday'}
    hours     = [[{:hours => monday_hours, :day => 'Monday'}]]
    strings   = [monday_hours, tuesday_hours, wednesday_hours, thursday_hours, friday_hours,
                 saturday_hours, sunday_hours]

    for i in 1..strings.length - 1
      hour_hash = {:hours => strings[i], :day => day_of_week[i]}

      if strings[i] == strings[i-1]
        hours.last << hour_hash
      else
        hours << [hour_hash]
      end
    end

    hours
  end

  def assign_coordinates
    latitude, longitude = geocode
  end

  def rails_admin_label
    "#{id} #{name}"
  end

end
