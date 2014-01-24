RailsAdmin.config do |config|
  config.model Urban::Image do
    object_label_method { :rails_admin_label }
  end
end
