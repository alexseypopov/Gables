if defined?(Associate) && Associate.table_exists?
  RailsAdmin.config do |config|
    [CorporateAssociate, CommunityAssociate].each do |associate_class|
      config.model associate_class do
        object_label_method { :rails_admin_label }

        list do
          field :featured
          field :name
          field :title
          field :description
          field :image, :carrierwave
          field :work
          field :career_path
          field :story
        end

        edit do
          field :featured
          field :name
          field :title
          field :description
          field :image, :carrierwave

          field :work, :text do
            ckeditor true
          end

          field :career_path, :text do
            ckeditor true
          end

          field :story do
            ckeditor true
          end
        end
      end
    end
  end
end
