class Tablet::InsiteController < Tablet::ApplicationController
  rescue_from Tablet::PortalWebService::TokenExpiredError, :with => :token_expired

  def find_guest
    concat_phone_numbers params[:guest]
    params[:guest].delete_if{|k,v| v.blank? }
    guests = Tablet::Guest.where(params[:guest])
    insite_guests = Tablet::PortalWebService.customer_search(params[:guest].merge(:token => params[:token]))
    render :json => guests + insite_guests.collect{|g| Tablet::Guest.from_insite(g)}
  end

  def guest_card
    guest = Tablet::PortalWebService.get_guest_card(
      :cust_record_key => params[:id],
      :prop_record_key => params[:property],
      :token           => params[:token]
    )
    tablet_guest = Tablet::Guest.from_insite(guest)
    tablet_guest.insite_id = params[:id]
    tablet_guest.tablet_insite_user_id = params[:key]
    tablet_guest.referrer_disabled = true if guest["CONT_RSOUR_RecordKey"].to_i != 0
    tablet_guest.save
    render :json => tablet_guest
  end

  def submit_guest_card
    tg = Tablet::Guest.find(params[:id])
    resp = Tablet::PortalWebService.submit_guest_card(tg, {
      :user_id            => params[:key],
      :property_insite_id => params[:property_insite_id],
      :token              => params[:token]
    }).first
    if resp and resp["PROC_Error"] == "NONE" and tg.email.present? and params[:send_email].present?
      Tablet::PropertyMailer.thank_you(tg, params.merge(resp)).deliver
    end
    render :json => resp
  end

  def token_expired
    render :text => "Your token has expired", :status => :unauthorized
  end

end
