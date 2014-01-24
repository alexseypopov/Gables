# Contains methods for updating existing records based on a new record e.g.
#
#   property(Property.new(:id => 5)) 
#
# will find an existing property with an id of 5 and update its attributes with those of the
# new property.
module Update
  class << self
    def property(new_model)
      core_model(Property, new_model, Floorplan, true)
    end

    def floorplans(new_models)
      new_models.map do |new_model|
        set_units_occupied(Floorplan.where(:gables_id => new_model.gables_id).first)
        core_model(Floorplan, new_model, Unit, true)
      end
    end
    
    def units(new_models)
      new_models.map do |new_model|
        core_model(Unit, new_model, nil, false)
      end
    end

    # Updates and saves new_model which is an instance of klass; optionally associates
    # new_model with children that are instances of child_class; optionally associates
    # new_model with images if imageable is true.
    #
    # N.B. Core models are those with gables_id i.e. floorplan, amenity, property
    def core_model(klass, new_model, child_class, imageable)
      model = if klass == Property
        klass.find_or_initialize_by_insite_id(new_model.insite_id)
      else
        klass.find_or_initialize_by_gables_id(new_model.gables_id)
      end
      update_attributes model, new_model
      model.vw_specials    = specials    model.vw_specials,   new_model.vw_specials
      model.vw_amenities   = amenities   model.vw_amenities,  new_model.vw_amenities
      model.vw_images      = images      model.all_images,     new_model.vw_images if imageable

      if child_class
        children = child_class.to_s.underscore.pluralize
        model.send("vw_#{children}=", send(children, new_model.send("vw_#{children}")))  # model.floorplans = floorplans new_model.floorplans
      end
      
      model.save!
      model
    end

    def specials(existing_association, new_models)
      new_models.map do |new_model|
        model = 
          existing_association.find_or_initialize_by_header_and_body(new_model.header, new_model.body)
        update_attributes model, new_model
        model.save!
        model
      end
    end

    def images(existing_association, new_models)
      new_models.map do |new_model|
        model = existing_association.find_or_initialize_by_vaultware_url(new_model.vaultware_url)
        update_attributes model, new_model
        model.remote_image_url  = new_model.vaultware_url if model.new_record? || !File.exists?(model.path)
        model.save!
        model
      end
    end

    def amenities(existing_association, new_models)
      new_models.map do |new_model|
        model =
          existing_association.find_or_initialize_by_description(new_model.description)
        update_attributes model, new_model
        model.save!
        model
      end
    end

private

    def set_units_occupied(floorplan)
      floorplan.units.each {|u| u.update_attributes(:occupied => true) } if floorplan
    end

    def remove_special_attributes(hash)
      hash.delete_if do |key, value|
        ["id", "created_at", "updated_at"].include?(key)
      end
    end

    def vaultware_attributes(model)
      model.attributes.delete_if do |key, value|
        !(model.class::VaultwareColumns.include?(key) || key == 'use_propertysolutions_data' )
      end
    end

    def update_attributes model, new_model
      model.vaultware_data = new_model.vaultware_data.clone
      unless model.use_propertysolutions_data?
        model.attributes = if [Property, Floorplan, Unit].include? model.class
          vaultware_attributes new_model
        else
          remove_special_attributes new_model.attributes
        end
      end
    end
  end
end
