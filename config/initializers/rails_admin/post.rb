if defined?(Post)
  RailsAdmin.config do |config|
    config.model Post do
      #object_label { "##{bindings[:object].id} #{bindings[:object].title}" }

      list do
        field :published
        field :featured
        field :kind
        field :image
        field :title
        field :summary
        field :text
        field :published_at, :date
      end

      edit do
        field :featured
        field :kind
        field :image
        field :title
        field :summary

        field :text, :text do
          ckeditor true
        end

        field :published
        field :published_at, :date
      end
    end
  end
end
