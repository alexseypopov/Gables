class GreenInitiative < ActiveRecord::Base
  belongs_to :green_category
  
  attr_accessible :name, :green_category_id

  SeedList = YAML::load File.open(Rails.root.join('db/green_initiative_seed_list.yml'), 'r') 

  # Loads the initial regions into the DB
  def self.seed
    SeedList.each do |name, fields|
      initiative = GreenInitiative.find_or_initialize_by_name(name)
      initiative.green_category_id  = GreenCategory.find_or_initialize_by_name(fields['category']).id
      initiative.save!
    end
  end
end
