class Schedule < Tableless
  column :first_name, :string  
  column :last_name, :string  
  column :phone, :string  
  column :alt_phone, :string  
  column :email, :string
  column :opt_in, :boolean  
  column :move_date, :string  
  column :visit_date1, :string  
  column :visit_time1, :string  
  column :visit_date2, :string  
  column :visit_time2, :string  
  column :community_id, :integer
  column :beds, :string
  column :rent_range, :string
  column :comments, :string
    
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true

  attr_accessible :first_name, :last_name, :phone, :alt_phone,
                  :email, :beds, :rent_range, :comments, :move_date,
                  :visit_date1, :visit_time1
  
  def times
    [['Best Time', ''], ['Morning', 'Morning'], ['Noon', 'Noon'], ['Afternoon', 'Afternoon']]
  end
end