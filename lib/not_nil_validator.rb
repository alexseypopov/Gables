# This validator must be used for every field whose table definition has :nil => false otherwise
# Rails will crash when saving the field without a value
class NotNilValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value.nil?
      object.errors[attribute] << (options[:message] || "must be entered") 
    end
  end
end
