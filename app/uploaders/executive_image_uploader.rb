# encoding: utf-8

class ExecutiveImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/executive_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
