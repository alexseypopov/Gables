RailsAdmin.config do |config|
  config.model SeoRegion do
    list do
      field :id
      field :region_id do
        formatted_value do
          Region.find(value).name
        end
      end
      field :created_at
      field :updated_at
    end
  end
end