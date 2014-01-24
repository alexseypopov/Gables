class GreenCategory < ActiveRecord::Base
  has_many :green_initiatives
  attr_accessible :name, :position, :green_initiative_ids
  SeedList = YAML::load File.open(Rails.root.join('db/green_category_seed_list.yml'), 'r') 

  # Loads the initial regions into the DB
  def self.seed
    SeedList.each do |name, fields|
      category = GreenCategory.find_or_initialize_by_name(name)
      category.position  = fields['position']
      category.save!
    end
  end
end
