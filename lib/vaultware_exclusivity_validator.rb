class VaultwareExclusivityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)

    record.send(attribute).each do |child|
      if !record.use_propertysolutions_data? and (record.from_vaultware? and !child.from_vaultware?)
        record.errors[attribute] << "contains non-vaultware #{child.class} #{child.id} but this #{record.class} is vaultware"
        break
      end
    end
  end
end
