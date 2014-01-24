if defined?(Gca::Region)
  RailsAdmin.config do |config|
    config.model Gca::Region do

      edit do
        field :city
        field :state

        field :properties do
          help "Start typing to see all matching items"
          orderable true
        end
      end
    end
  end
end
