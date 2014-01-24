# encoding: utf-8

class Urban::BrochureUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/urban_brochures/#{model.id}"
  end
end
