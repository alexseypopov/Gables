RailsAdmin.config do |config|
  config.model Image do
    label "Image (Floorplan/Property)"
    object_label_method { :rails_admin_label }

    list do
      field :id
      field :url
      field :from_vaultware
      field :from_propertysolutions
      field :use_propertysolutions_data
      field :vaultware_url
      field :imageable_type
      field :imageable_id
      field :created_at
      field :updated_at
    end

   edit do
      field :id do
        partial 'uneditable_notice'
        visible { bindings[:object].from_vaultware or bindings[:object].from_propertysolutions }
      end

     field :image do
       visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
     end

     field :imageable_id do
       visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
     end
   end
  end
end
