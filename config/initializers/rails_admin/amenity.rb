RailsAdmin.config do |config|
  config.model Amenity do
    object_label_method do
      :custom_label_method
    end

    list do
      field :id
      field :from_vaultware
      field :from_propertysolutions
      field :use_propertysolutions_data
      field :description
      field :rank
      field :created_at
      field :updated_at
    end

    edit do
      field :id do
        partial 'uneditable_notice'
        visible { bindings[:object].from_vaultware or bindings[:object].from_propertysolutions }
      end

      field :description do
        visible { not bindings[:object].from_vaultware }
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :rank do
        visible { not bindings[:object].from_vaultware }
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :units do
        help "Start typing to see all matching items"
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :floorplans do
        help "Start typing to see all matching items"
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :properties do
        help "Start typing to see all matching items"
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    end
  end
end
