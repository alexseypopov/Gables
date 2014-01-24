class Gca::MaintenanceRequest < Tableless
  column :name, :string  
  column :company, :string  
  column :community, :string  
  column :aptnumber, :string  
  column :phone, :string  
  column :email, :string
  column :city, :string
  column :state, :string
  column :request_type, :string
  column :other, :string
end