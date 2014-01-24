# encoding: utf-8

class Gca::PromoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "assets/gca_promo_images/#{model.id}"
  end

  def default_url
    "/images/no_image.gif"
  end
end
