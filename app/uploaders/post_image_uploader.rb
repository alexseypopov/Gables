# encoding: utf-8

class PostImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::RMagick
  storage :file

  def store_dir
    "assets/post_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
