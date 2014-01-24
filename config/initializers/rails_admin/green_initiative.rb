if defined?(GreenInitiative) && GreenInitiative.table_exists?
  RailsAdmin.config do |config|
    config.model GreenInitiative do

      list do
        field :id
        field :name
        field :green_category
      end
    
      edit do
        field :name
        field :green_category
      end
    end
  end
end