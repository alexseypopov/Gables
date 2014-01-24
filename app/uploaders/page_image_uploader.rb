# encoding: utf-8

class PageImageUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::RMagick

  def store_dir
    "assets/page_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end

  version :thumb do
    process :resize_to_fit => [137, 85]
  end
end
