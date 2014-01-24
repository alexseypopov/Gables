class Gca::Contact < Tableless
  column :first_name, :string  
  column :last_name, :string  
  column :address, :string  
  column :address2, :string  
  column :city, :string  
  column :state, :string  
  column :zip, :string
  column :email, :string
  column :company, :string  
  column :company_address, :string  
  column :company_address2, :string  
  column :company_city, :string  
  column :company_state, :string  
  column :company_zip, :string
  column :primary, :string  
  column :phone, :string 
  column :phone2, :string 
  column :fax, :string  
  column :furnished, :string  
  column :arrival_date, :string  
  column :departure_date, :string  
  column :requested_city, :string  
  column :requested_state, :string  
  column :school_district, :string  
  column :apartment_type, :string  
  column :work_location, :string  
  column :budget, :string  
  column :comments, :string  
  column :find_us, :string  
  column :housing_type, :string  
  column :pets, :string  
    
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true
  validates :arrival_date, :presence => true
  validates :departure_date, :presence => true
  validates :requested_city, :presence => true
  validates :requested_state, :presence => true
  validates :budget, :presence => true
  
  def apt_type
    [
      'Studio',
      'One Bedroom',
      'Two Bedroom',
      'Three Bedroom'
    ]
  end
  
  def find_options
    [
      'Google',
      'Yahoo',
      'Bing',
      'Other search engine',
      'Word of mouth',
      'Company referral',
      'Gables community',
      'Other'
    ]
  end
  
  def housing_types
    [
      'Business Travel',
      'Relocation',
      'Vacation',
      'Insurance',
      'Other'
    ]
  end
end