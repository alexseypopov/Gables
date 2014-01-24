if defined?(Urban::Property)
  RailsAdmin.config do |config|
    config.model Urban::Property do
      object_label_method { :rails_admin_label }

      list do
        field :id
        field :name
        field :phone
        field :street
        field :city
        field :state
        field :zip
        field :email
        field :short_description
        field :long_description
        field :opening_year
        field :apartments_count
        field :square_footage
        field :site_url
        field :map_url
      end

      edit do
        field :name
        field :position
        field :phone
        field :street
        field :city
        field :state, :enum
        field :zip
        field :email
        field :short_description
        field :long_description
        field :opening_year
        field :apartments_count
        field :square_footage
        field :site_url
        field :map_url

        field :shopping_etc, :text do
          ckeditor true
        end

        field :images do
          help "Start typing to see all matching items"
          orderable true
        end

        field :full_brochure do
          label "Brochure PDF"
        end
      end
    end
  end
end
