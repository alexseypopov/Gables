RailsAdmin.config do |config|
  config.model Unit do
    object_label_method { :rails_admin_label }

    list do
      field :id
      field :from_vaultware
      field :from_propertysolutions
      field :use_propertysolutions_data
      field :name
      field :gables_id
      field :available_on
      field :occupied
      field :building_name
      field :rent_min
      field :rent_max
      field :entry_floor
      field :area_min
      field :area_max
      field :floorplan_id
      field :created_at
      field :updated_at
    end

    edit do
      field :id do
        partial 'uneditable_notice'
        visible { bindings[:object].from_vaultware or bindings[:object].from_propertysolutions }
      end

      field :name do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :available_on do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :occupied do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :building_name do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :rent_min do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :rent_max do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :entry_floor do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :area_min do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :area_max do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :floorplan_id do
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
