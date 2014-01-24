RailsAdmin.config do |config|
  [HomeSlide, Gca::HomeSlide, Urban::HomeSlide].each do |slide_class|
    config.model slide_class do

      edit do
        field :image
        field :position
        field :title
        field :subtitle
        field :description
      end
    end
  end
end
