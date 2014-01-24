# encoding: utf-8

class Urban::ImageUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::RMagick

  version :thumb do
   process :resize_to_fit => [275, 275]
  end

  version :large do
    process :resize_to_fit => [640,407]
  end

  def store_dir
    "assets/urban_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
