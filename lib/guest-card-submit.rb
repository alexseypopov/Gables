unsubmitted = {}

Tablet::Guest.where(:guest_card_id => nil).each do |tg|
  user = Tablet::PortalWebService.authenticate_insite_user({
    :username => "mktg01", :password => "Ga122110", :property => 59
  })
  resp = Tablet::PortalWebService.submit_guest_card(tg, {
    :property_insite_id => tg.tablet_property_id,
    :user_id            => tg.tablet_insite_user_id,
    :token              => user[:token]
  }).first
  puts resp
  if resp and resp["PROC_Error"] == "NONE"
    tg.guest_card_id = resp["CONT_RecordKey"]
    tg.insite_id     = resp["CUST_RecordKey"]
    tg.save
  else
    unsubmitted[tg] = resp
  end
end

unsubmitted.group_by do |guest, resp|
  guest.tablet_insite_user_id
end.each do |user_id, guests|
  if user = Tablet::InsiteUser.find_by_id(user_id)
    Tablet::GuestCardMailer.failed_guest_cards(
      :to => user.email, :guests => guests
    ).deliver
  end
end

unsubmitted.group_by do |guest, resp|
  guest.tablet_property_id
end.each do |property_id, guests|
  if property = Tablet::Property.find_by_id(property_id)
    Tablet::GuestCardMailer.failed_guest_cards(
      :to     => property.community_manager_email,
      :guests => guests
    ).deliver
  end
end
