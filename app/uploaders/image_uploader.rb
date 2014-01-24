# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::RMagick

  version :thumb do
    process :resize_to_fit => [275, 275]
  end

  version :large do
    process :resize_to_fit => [640,407]
  end

  def store_dir
    "assets/images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
