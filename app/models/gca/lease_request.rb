class Gca::LeaseRequest < Tableless
  column :name, :string  
  column :company, :string  
  column :community, :string  
  column :aptnumber, :string  
  column :phone, :string  
  column :email, :string
  column :vacate, :string
  column :vacate_date, :string
  column :extend, :string
  column :extend_date, :string
  column :questions, :string
end