class Gca::ContactMailer < ActionMailer::Base
  
  def contact(info)
    case Rails.env
      when 'development'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'staging'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'production'
        notification_recipients = 'nationalsales@gables.com'
      else
        notification_recipients = ''
    end
    
    subject    'Gables GCA: Contact Submission'
    recipients  notification_recipients
    from       'info@gables.com'
    sent_on    Time.now
    content_type "text/html"
    @info = info
  end
  
  def maintenance(info)
    case Rails.env
      when 'development'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'staging'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'production'
        notification_recipients = 'service@gables.com'
      else
        notification_recipients = ''
    end
    
    subject    'Gables GCA: Maintenance Request'
    recipients  notification_recipients
    from       'service@gables.com'
    sent_on    Time.now
    content_type "text/html"
    @info = info
  end
  
  def lease(info)
    case Rails.env
      when 'development'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'staging'
        notification_recipients = 'greg.greiner@digitalscientists.com'
      when 'production'
        notification_recipients = 'gcarent@gables.com'
      else
        notification_recipients = ''
    end
    
    subject    'Gables GCA: Extend Lease / Vacate Request'
    recipients  notification_recipients
    from       'info@gables.com'
    sent_on    Time.now
    content_type "text/html"
    @info = info
  end

end