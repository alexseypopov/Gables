module PropertySolutions
  module Import
    class AbstractWraper

      def self.map attr_name, path_to_value, type
        define_method attr_name do
          send "_#{type}", get_value(path_to_value)
        end
      end

      def self.to_sym
        name.demodulize.downcase.to_sym
      end

      def self.inherited base
        if MAPPING.keys.include? base.to_sym
          base.map_attributes MAPPING[base.to_sym]
        end
      end
     
      def self.map_attributes attrs
        attrs.each do |attr, mapping|
          if mapping[2] == :private
            (@private_attributes ||= []) << attr
          elsif mapping[2] == :association
            (@associations ||= []) << attr
          else
            (@attributes ||= []) << attr
          end
          map attr, mapping[0], mapping[1]
        end
      end

      def self.attributes
        @attributes || []
      end

      def self.private_attributes
        @private_attributes || []
      end

      def self.associations
        @associations || []
      end


      def initialize source
        @source = source
      end

      def get_value path, params={}
        path = path.clone
        path.scan(/{#(\w+)}/).each { |attr| path.gsub!("{##{attr.first}}", send(attr.first).to_s) }
        get_value_from_source @source, path
      end

      def get_value_from_source source, original_path
        path = original_path.split('/')
        node = source
        while key = path.shift
          current_node = if key.match /\[.+\]/
            tmp_key = key.match(/(.+)\[.+\]/)[1]
            tmp_path, criteria = key.match(/\[(.+)=(.+)\]/)[1..2]
            tmp_path.gsub!('\\', '/')
            if node[tmp_key].present?
              node[tmp_key].select {|n| get_value_from_source(n, tmp_path).to_s == criteria }
            else
              []
            end
          else
            key = key.to_i if node.is_a? Array
            node[key]
          end
          current_node.merge!('..' => node) if current_node.is_a? Hash
          node = current_node
        end
        node
      rescue NoMethodError => e
        #puts "WARNING!"
        #puts "failed to get value by path: #{original_path}"
        #puts "entry type: #{self.class.name.demodulize}"
        nil
      end

      def _integer value
        value.to_i
      end

      def _decimal value
        value.to_f
      end

      def _text value
        value.to_s
      end

      def _date value
        Date.new(value['Year'].to_i, value['Month'].to_i, value['Day'].to_i) unless value.nil?
      end

      def _boolean value
        value.present?
      end

      def _amenities value
        (value || []).map do |source|
          Import::Amenity.new source.merge('..' => @source)
        end
      end

      def _specials value
        (value || []).map do |source|
          Import::Special.new source.merge('..' => @source)
        end
      end

      def _images value
        (value || []).map do |source|
          Import::Image.new source
        end
      end

      def attributes
        unless @attributes.present?
          @attributes = {}
          self.class.attributes.each do |attr|
            @attributes[attr] = send attr
          end
        end
        @attributes
      end

      def associations
        unless @associations.present?
          @associations = {}
          self.class.associations.each do |attr|
            @associations[attr] = send attr
          end
        end
        @associations
      end

    end
  end
end
