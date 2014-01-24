class Tablet::UnitsController < ActionController::Base
  layout 'tablet/application'
  rescue_from Tablet::PortalWebService::TokenExpiredError, :with => :token_expired
  caches_action :index, :expires_in => 1.day

  def index
    property = ::Property.find(params[:tablet_property_id])
    units = Tablet::PortalWebService.get_available_units(
      :prop_record_key => property.insite_id,
      :token => params[:token]
    )
    grouped_units = property.floorplans.collect do |fp|
      fp.as_json.merge(:units => units.select do |u|
          u["PUTYPE_VaultwareID"] == fp.gables_id
        end
      )
    end

    respond_to do |format|
      format.html {}
      format.json { render :json => grouped_units }
    end
  end

  def expire
    expire_action :action => :index, :format => :json
    render :text => "success"
  end

  def nearby
    units = Tablet::PortalWebService.get_available_units_nearby(
      :prop_record_key => params[:insite_id],
      :token => params[:token]
    )
    respond_to do |format|
      format.json { render :json => units.group_by{|u| u["Property"]} }
    end
  end

  def token_expired
    render :text => "Your token has expired", :status => :unauthorized
  end

end
