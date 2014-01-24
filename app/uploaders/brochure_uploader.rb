# encoding: utf-8

class BrochureUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/brochures/#{model.id}"
  end
end
