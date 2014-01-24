RailsAdmin.config do |config|
  [Block, Gca::Block, Urban::Block, PageBlock].each do |block_class|
    config.model block_class do
      object_label_method do
        :rails_admin_label
      end

      edit do
        field :id do
          partial 'uneditable_notice'
          visible { !bindings[:object].editable }
        end

        field :title do
          visible { bindings[:object].editable }
        end

        field :content, :text do
          ckeditor true
          visible { bindings[:object].editable }
        end
      end
    end
  end
end
