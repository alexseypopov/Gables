class ContactMailer < ActionMailer::Base

  def schedule(info, property, history)
    case Rails.env
      when 'development'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'staging'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'production'
        if property.contact_form_email.present?
          notification_recipients = property.contact_form_email
        else
          notification_recipients = 'tsmith@gables.com'
        end
      else
        notification_recipients = ''
    end

    if info.visit_date1.blank? && info.visit_time1.blank?
      subject = 'Gables Website: Information Request'
    else
      subject = 'Gables Website: Visit Schedule'
    end
    recipients = notification_recipients
    from = 'info@gables.com'
    content_type = "text/html"
    @info = info
    @property = property
    @history = history
    mail({
      to: recipients, 
      from: from,
      subject: subject, 
      content_type: content_type,
    })
  end

  def contact(info)
    setting = Setting.find_by_key("contact-email")
    if info.subdomain.include?('urban')
      notification_recipients = 'retail@gables.com'
    else
      notification_recipients = setting ? setting.value : 'tsmith@gables.com'
    end

    if info.property.present?
      property = Property.find(info.property)
      @property = property
      if info.visitor_type.blank?
        if property && property.tablet_property && property.tablet_property.community_manager_email
          notification_recipients = property.tablet_property.community_manager_email
        elsif property && property.contact_form_email.present?
          notification_recipients = property.contact_form_email
        end
      end
    end

    if info.urban_property.present?
      property = Urban::Property.find(info.urban_property)
      @property = property
      if property && !property.email.blank?
        notification_recipients = property.email
      end
    end

    subject    = 'Gables Website: Contact'
    recipients =  notification_recipients
    from       = 'info@gables.com'
    content_type = "text/html"
    @info = info

    mail({
      to: recipients, 
      from: from,
      subject: subject, 
      content_type: content_type,
    })
  end

end
