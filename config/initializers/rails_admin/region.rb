RailsAdmin.config do |config|
  config.model Region do

    list do      
      field :id
      field :for_seo
      field :name
      field :description
      field :latitude
      field :longitude
      field :created_at
      field :updated_at
    end

    edit do
      field :name
      field :for_seo
      field :description, :text do
        ckeditor true
      end

      field :latitude
      field :longitude
      field :created_at
      field :updated_at

      field :properties do
        help "Start typing to see all matching items"
      end
    end
  end
end
