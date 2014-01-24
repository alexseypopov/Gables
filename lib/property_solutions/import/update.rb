module PropertySolutions
  module Import
    class Update

      FINDERS = {
        :property => [:insite_id],
        :floorplan => [:gables_id],
        :unit => [:gables_id],
        :amenity => [:description],
        :image => [:propertysolutions_url],
        :special => [:header, :body]
      }

      SCOPED_ASSOCIATIONS = [
        :amenities, :images, :specials
      ]
      
      def self.update raw, scope=nil
        subj = fetch *([raw, scope].compact)
        unless [0,4].include? raw.insite_id.to_i
          subj.use_propertysolutions_data = true if subj.new_record?
          subj.from_propertysolutions = true
          update_attributes subj, raw.attributes
          subj.save!
          update_associations subj, raw.associations
        end
        subj
      end

      def self.fetch raw, scope=nil
        klass = "::#{raw.class.name.demodulize.to_s.capitalize}".constantize 
        scope = scope.nil? ? klass : scope
        finder = FINDERS[raw.class.to_sym]

        subj = scope.send :"find_by_#{finder.join('_and_')}", *(finder.map { |attr| raw.send attr })
        if subj.nil?
          subj = klass.new
          finder.each do |attr|
            subj.send :"#{attr}=", raw.send(attr)
          end
        end
        subj
      end

      def self.update_attributes subj, attributes
        subj.propertysolutions_data = attributes.to_json
        if subj.use_propertysolutions_data?
          attributes.each do |attr_name, value|
            subj.send :"#{attr_name}=", value unless value.nil?
          end
          if subj.is_a?(::Image) && ( subj.new_record? || !File.exists?(subj.path.to_s) )
            begin
            subj.remote_image_url = attributes[:propertysolutions_url]
            rescue OpenURI::HTTPError, CarrierWave::DownloadError => e
              puts "File not found #{attributes[:propertysolutions_url]}"
            end
          end
        end
      end

      def self.update_associations subj, associations
        associations.each do |name, values|
          update_association subj, name, values
        end
      end

      def self.update_association subj, association_name, values

        old_records = subj.send(:"all_#{association_name}")
        old_records.update_all(:from_propertysolutions => false)
        updated_records = values.map do |raw|
          unless SCOPED_ASSOCIATIONS.include? association_name
            update raw
          else
            update raw, subj.send(:"all_#{association_name}")
          end
        end

        updated_record_ids = updated_records.map(&:id)
        old_records = old_records.where('id NOT IN (?)', updated_record_ids)
        
        subj.send(:"ps_#{association_name}=", updated_records)
      end

    end
  end
end

