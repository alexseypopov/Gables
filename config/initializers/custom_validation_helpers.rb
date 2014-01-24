ActiveRecord::Base.class_eval do
  def self.validates_non_nilness_of(*attr_names)
    attr_names.each do |attr_name|
      validates attr_name, :not_nil => true
    end
  end
end
