class Contact < Tableless
  attr_accessible :first_name, :last_name, :phone, :email, :message, 
    :property, :urban_property, :visitor_type, :subdomain, :opt_in
    
  column :first_name, :string  
  column :last_name, :string  
  column :phone, :string  
  column :email, :string  
  column :message, :text
  column :property, :text
  column :urban_property, :text
  column :visitor_type, :string
  column :subdomain, :string
  column :opt_in, :boolean
    
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true
  validate :has_prop_when
  
  def has_prop_when
    if visitor_type == 'Resident'
      errors.add(:property, "must be selected for Resident requests") unless property != ''
    end
  end
end
