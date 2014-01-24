class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_constants, :except => [:path, :error_404]
  before_filter :set_mobile_path

  layout Proc.new { |controller| 
    controller.request.subdomain =~ /mobile/ ? 
      'mobile/layouts/application' : 'layouts/application'
    controller.request.subdomain =~ /mobile.urban/ ? 
      'mobile/layouts/application' : 'layouts/application'
  } 

  def set_mobile_path
    if request.subdomain =~ /mobile/
      prepend_view_path "app/views/mobile"
    end
    
  end

  def error_404
    render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
  end

  def get_constants
    @footer_news = Post.featured.limit(1)
    @property_links = Property.published.select([:id,:name,:city,:state])
    @live_search_options = live_search
    @states = @property_links.map(&:state).sort.uniq
  end

  def clear_cache
    if current_user.present? && current_user.administers_residential?
      system "rake gables:clear_cache RAILS_ENV=#{Rails.env}"
      render :text => 'Cache Cleared'
     else
      redirect_to new_user_session_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

private

  # Returns a list of names of states, cities, regions and properties
  # => [String]
  def live_search
    regions     = Region.select("DISTINCT(name)").map(&:name)
    property_names = @property_links.map(&:name)
    states      = @property_links.map(&:state).uniq.map{|state| Carmen::state_name(state) }
    cities      = @property_links.map(&:city).uniq

    (regions | property_names | states | cities).compact.sort
  end
end
