class Tablet::PropertyMailer < ActionMailer::Base
  default :from => "Gables.com <contact@gables.com>"

  def email_brochure(to, file, name)
    attachments[file.file.filename] = File.read file.path
    mail :to => to, :subject => "#{name} brochure"
  end

  def email_pdf(to, file, name)
    attachments["#{name}-floorplan.pdf"] = {mime_type: 'application/pdf',content: file}
    mail :to => to, :subject => "#{name} Floorplan PDF"
  end

  def thank_you(guest, options={})
    @guest = guest
    @note = options[:note]
    if unit_id = options[:unit_id]
      @unit_id = "%08d" % unit_id.to_i
      @cust_id = "%08d" % options[:CUST_RecordKey]
      subject = "Your Gables Online Application login"
    end
    @floorplans = Floorplan.where :gables_id => [
      @guest.preferred_unit_type1,@guest.preferred_unit_type2
    ]
    if @property = ::Property.where(:insite_id => options[:property_insite_id]).first
      if @guest.floorplan_brochure
        attachments[
          @property.full_brochure.file.filename
        ] = File.read @property.full_brochure.path
      end
      if @guest.community_brochure
        attachments[
          @property.short_brochure.file.filename
        ] = File.read @property.short_brochure.path
      end
      if @guest.building_specifications
        attachments[
          @property.building_specifications_file.file.filename
        ] = File.read @property.building_specifications_file.path
      end
      subject = "Thank you for visiting #{@property.name}" if @note
    end
    mail :to => guest.email, :subject => subject
  end

end
