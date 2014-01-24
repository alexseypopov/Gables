class Tablet::GuestCardMailer < ActionMailer::Base
  default :from => "Gables.com <contact@gables.com>"

  def failed_guest_cards(options={})
    @guests = options[:guests]
    email = options[:to]
    mail :to => email, :subject => "Failed to Submit these Guest Cards"
  end

  def archived_guest_cards(options={})
    filename = options[:filename]
    attachments[filename] = File.read "tmp/#{filename}"
    email = options[:to].community_manager_email
    mail :to => email, :subject => "Archived Guest Cards"
  end
end
