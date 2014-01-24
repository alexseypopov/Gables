class UserSearch < ActiveRecord::Base
  
  def self.save_or_add(query)
    r = find_or_create_by_query(query)
    r.count = r.count ? r.count+1 : 1
    r.save
  end
end
