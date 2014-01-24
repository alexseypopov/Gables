RailsAdmin.config do |config|
  config.model Special do
    object_label_method do
      :rails_admin_label
    end

    list do
      field :id
      field :from_vaultware
      field :from_propertysolutions
      field :use_propertysolutions_data
      field :header
      field :body
      field :specialable_id
      field :created_at
      field :updated_at
    end

    edit do
      field :id do
        partial 'uneditable_notice'
        visible { bindings[:object].from_vaultware or bindings[:object].from_propertysolutions }
      end

      field :header do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :body do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end

      field :specialable_id do
        visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
      end
    end
  end
end
