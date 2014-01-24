class Tablet::InsiteUser < ActiveRecord::Base
  has_many :guests, :foreign_key => "tablet_insite_user_id"
end
