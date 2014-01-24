class Tablet::SessionsController < ActionController::Base
  respond_to :json

  def create
    user = Tablet::PortalWebService.authenticate_insite_user(params[:session])
    if user[:error] == "Tablet application access denied."
      render :json => {:error => "Access to tablet is denied"}, :status => 420
    elsif user[:error] == "Property Access Denied"
      render :json => {:error => "Access to community is denied"}, :status => 421
    elsif user[:error] != "NONE" or user[:token].blank?
      render :json => {:error => "Invalid username and/or password"}, :status => 422
    else
      insite_user = Tablet::InsiteUser.find_by_id(user[:key])
      render :json => {
        :user  => user.merge({
          request_forgery_protection_token => form_authenticity_token,
          :name => insite_user && insite_user.name || user[:user].split(",").reverse.join(" "),
          :email => insite_user && insite_user.email,
          :pendingGuests => Tablet::Guest.where(
            :tablet_insite_user_id => user[:key],
            :tablet_property_id => params[:session][:property]
          ).count
        })
      }
    end
  end

end
