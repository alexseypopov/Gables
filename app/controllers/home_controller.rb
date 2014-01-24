class HomeController < ApplicationController
  def contact
    @regions = Region.all
  end

  def equal_employment
    @section = 'careers'
  end

  def privacy
    @section = 'company'
  end
  
  def vaultware
    ActionController::Base.asset_host = request.host_with_port
    render :layout => 'sectional'
  end
  
  def recent_searches
    @searches = UserSearch.order('updated_at desc').limit(2000)
  end

  def tablet
    render :layout => 'tablet'
  end

  def language
    render :text => request.headers["HTTP_ACCEPT_LANGUAGE"]
  end
end
