# encoding: utf-8

class AssociateImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/associate_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
