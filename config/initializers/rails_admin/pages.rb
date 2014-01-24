if defined?(Page)
  [LifePage, CompanyPage, CareerPage, Gca::ServicesPage, Gca::ToplevelPage,
   Urban::ServicesPage, Urban::ToplevelPage].each do |page_class|
    RailsAdmin.config do |config|
      config.model page_class do

        edit do
          field :published
          field :show_in_nav
          field :path
          field :name
          field :subtitle
          field :title
          field :description
          field :position
          field :image#, :carrier_wave_image
          
          field :side_blocks do
            help "Start typing to see all matching items"
            orderable true
          end

          field :main_blocks do
            help "Start typing to see all matching items"
            orderable true
          end
        end
      end
    end
  end
end
