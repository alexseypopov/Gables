module DataSourceSwitch

  def self.included base
    base.send :before_save, :toggle_data_source
    update_associations base
  end

  def self.update_associations base
    if base == Property
      [:floorplans, :amenities, :images, :units, :specials].each do |assoc|
        modify_association base, assoc
      end
    elsif base == Floorplan
      [:units, :images, :amenities, :specials].each do |assoc|
        modify_association base, assoc
      end
    elsif base == Unit
      [:amenities, :specials].each do |assoc|
        modify_association base, assoc
      end
    end
  end

  def self.modify_association base, association_name
    refl = base.reflections[association_name]
    options = refl.options.clone
    refl_macro = refl.macro
    base.send :alias_method, :"all_#{association_name}", association_name
    vw_options = options.clone
    ps_options = options.clone
    vw_options[:class_name] = association_name.to_s.singularize.capitalize
    ps_options[:class_name] = association_name.to_s.singularize.capitalize

    vw_options[:conditions] = (vw_options[:conditions] || {}).merge(:from_vaultware => true)
    ps_options[:conditions] = (ps_options[:conditions] || {}).merge(:from_propertysolutions => true)

    base.send refl_macro, :"vw_#{association_name}", vw_options
    base.send refl_macro, :"ps_#{association_name}", ps_options

    base.send :define_method, association_name do |options={}|
      if use_propertysolutions_data? && from_propertysolutions?
        self.send :"ps_#{association_name}", options
      elsif !use_propertysolutions_data? && from_vaultware?
        self.send :"vw_#{association_name}", options
      else 
        self.send :"all_#{association_name}", options
      end

    end
  end

  def association_condition association_name

    reflections[association_name].options[:conditions] = self.send(:"#{association_name}_conditions")
  end

  def apply_propertysolutions_data
    JSON.parse(propertysolutions_data || '{}').each_pair do |k,v|
      write_attribute k, v
    end
    if instance_of?(Image)
      begin
        remote_image_url = propertysolutions_url
      rescue OpenURI::HTTPError, CarrierWave::DownloadError => e
        puts "File not found #{propertysolutions_url}"
      end
    end
  end

  def apply_vaultware_data
    JSON.parse(vaultware_data || '{}').each_pair do |k,v|
      write_attribute k, v
    end
    if instance_of?(Image)
      begin
        self.remote_image_url = self.vaultware_url
      rescue OpenURI::HTTPError, CarrierWave::DownloadError => e
        puts "File not found #{vaultware_url}"
      end
    end
  end

  def backup_propertysolutions_data
    backup = {}
    attrs_to_backup.each do |c|
      backup[c] = self.read_attribute(c)
    end
    self.propertysolutions_data = backup.to_json
  end

  def backup_vaultware_data
    backup = {}
    attrs_to_backup.each do |c|
      backup[c] = self.read_attribute(c)
    end
    self.vaultware_data = backup.to_json
  end

  def attrs_to_backup
    if defined?(PropertysolutionsColumns) && defined?(VaultwareColumns)
      if use_propertysolutions_data? 
        PropertysolutionsColumns 
      else 
        VaultwareColumns
      end
    else
      attributes.keys - %w{id created_at updated_at imageable_id imageable_type propertysolutions_data vaultware_data use_propertysolutions_data from_vaultware from_propertysolutions speciable_id speciable_type}
    end
  end

  def toggle_data_source
    if use_propertysolutions_data_changed? && persisted?
      if use_propertysolutions_data?
        backup_vaultware_data
        apply_propertysolutions_data
      else
        backup_propertysolutions_data
        apply_vaultware_data
      end
      update_relations
    end
  end

  def update_relations
    if instance_of? Property
      floorplans + amenities + images
    elsif instance_of? Floorplan
      units + images
    else
      []
    end.each do |item|
      item.use_propertysolutions_data = self.use_propertysolutions_data
      item.save
    end
  end

end
