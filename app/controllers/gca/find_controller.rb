class Gca::FindController < Gca::ApplicationController
  layout 'gca/application'
  
  def where
    @region = Gca::Region.find_by_city_and_state(params[:city], params[:state])
    if @region && @region.properties.published.length > 0
      @section = 'properties'
      @query = "#{params[:city]} #{params[:state]}"
      @properties = @region.properties.published.paginate(:per_page => 3, :page => params[:page] || 1)
    else
      redirect_to url_for(:controller => 'gca/home', :action => 'contact', :subdomain => 'gca')
    end
  end
  
  def community
    @section = 'properties'
    @property = Property.published.find params[:id]
    @green_categories = GreenCategory.order('position ASC')
  rescue ActiveRecord::RecordNotFound
    error_404
  end
end
