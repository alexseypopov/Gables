class Urban::HomeController < ApplicationController
  layout 'urban/application'

  def index
    @sliders = Urban::HomeSlide.by_position_asc
    @footer_news = Post.featured.limit(3)
    @promos = Urban::Promo.by_position_asc.limit(3)
  end
  
  def properties
    @section = 'properties'
    @properties = Urban::Property.order('position ASC')
    @cities = Urban::Property.select("DISTINCT(city)").order('city').map(&:city)
  end
end
