class Special < ActiveRecord::Base
  belongs_to :specialable, :polymorphic => true
  validates_non_nilness_of :body, :header, :from_vaultware
  attr_accessible :header, :body, :from_vaultware, :specialable_id, :specialable_type, :use_propertysolutions_data, :from_propertysolutions, :propertysolutions_data, :vaultware_data
  include DataSourceSwitch

  def rails_admin_label
    "#{id} #{header}"
  end
end
