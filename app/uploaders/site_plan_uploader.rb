class SitePlanUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file

  version :thumb do
    process :resize_to_fill => [115, 96]
  end

  def store_dir
    "assets/site_plans/#{model.id}"
  end

end
