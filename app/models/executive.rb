class Executive < ActiveRecord::Base
  mount_uploader :image, ExecutiveImageUploader

  validates_non_nilness_of  :name, :title, :category

  attr_accessible :name, :title, :office_address, :phone, :email, :bio, :image, :category, :position

  def category_enum
    ["Company Officer", "Operations", "Corporate", "Development & Construction"]
  end
end
