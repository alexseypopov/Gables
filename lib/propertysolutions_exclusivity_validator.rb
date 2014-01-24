class PropertysolutionsExclusivityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)

    record.send(attribute).each do |child|
      if record.use_propertysolutions_data? and (record.from_propertysolutions? and !child.from_propertysolutions?)
        record.errors[attribute] << "contains non-propertysolutions #{child.class} #{child.id} but this #{record.class} is propertysolutions"
        break
      end
    end
  end
end

