if defined?(Gca::Promo)
  RailsAdmin.config do |config|
    config.model Gca::Promo do

      edit do
        field :image
        field :heading
        field :text
        field :link
        field :position

        field :video_id do
          label "Video id"
          help "e.g. in http://www.youtube.com/watch?v=xF8MAE, the id is 'xF8MAE'"
        end
      end
    end
  end
end
