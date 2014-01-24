# encoding: utf-8

class LifeSlideImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/life_slide_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
