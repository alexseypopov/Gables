class Gca::ApplicationController < ApplicationController
  before_filter :get_gca_regions
  
  def get_gca_regions
    @gca_regions = Gca::Region.select("DISTINCT(state)").map(&:state).sort
  end
end
