require 'net/ftp'

class Vaultware
  class <<self
    def import(file_path=nil)
      Rails.logger.warn "Started importing at #{Time.now}"
      file_path ||= fetch
      doc = xml(file_path)

      Load::xpath(doc, "//Property").each_with_index do |child, i|
        p = Load::property(child, ".")
        Update::property(p) unless [0,4, nil].include? p.insite_id
        Rails.logger.warn "imported #{i+1}\t#{p.name}"
      end

      clear_orphan_core_models
      create_new_regions
      Rails.logger.warn "Finished importing at #{Time.now}"
    end

    def fetch
      host      = 'ftp.vaultware.com'
      username  = 'GablesFTP'
      password  = 'G@bl3$'
      path      = 'gablescom.xml'

      tempfile  = Tempfile.new('gables')
      ftp       = Net::FTP.new(host)
      ftp.login(username, password)
      ftp.passive = true
      ftp.get(path, tempfile.path)

      Rails.logger.debug "XML file downloaded to #{tempfile.path}"
      return tempfile.path
    end

    def xml(file_path)
      Nokogiri::XML(open(file_path))
    end

    def clear_orphan_core_models
      Floorplan.destroy_all(:property_id => nil)
    end

    def create_new_regions
      Property.select("DISTINCT(city),state").each do |p|
        region = Gca::Region.find_or_create_by_city_and_state(p.city, p.state)
      end
      Gca::Region.attach_properties
    end
  end
end
