RailsAdmin.config do |config|
  config.model Floorplan do
    object_label_method { :rails_admin_label }

    list do
      field :id
      field :from_vaultware
      field :from_propertysolutions
      field :use_propertysolutions_data
      field :name
      field :gables_id
      field :bedrooms_count
      field :bathrooms_count
      field :area_min
      field :area_max
      field :property_id
      field :created_at
      field :updated_at
      field :images
    end

    edit do
      field :id do
        partial 'uneditable_notice'
        visible { bindings[:object].from_vaultware or bindings[:object].from_propertysolutions }
      end

      field :name do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    
      field :bedrooms_count do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    
      field :bathrooms_count do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    
      field :area_min do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    
      field :area_max do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    
      field :images do
        help "Start typing to see all matching items"
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :property_id do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :units do
        help "Start typing to see all matching items"
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :specials do
        help "Start typing to see all matching items"
        visible { not bindings[:object].from_vaultware }
      end

      field :amenities do
        help "Start typing to see all matching items"
        visible { not bindings[:object].from_vaultware }
      end
    end
  end
end
