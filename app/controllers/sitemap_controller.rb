class SitemapController < ApplicationController
  respond_to :xml

  def show
    properties  = Property.published
    floorplans  = properties.map(&:floorplans).flatten
    @models     = sort_by_updated_at_desc(floorplans + properties + Region.all)
    render :layout => false
  end

private
  def sort_by_updated_at_desc(models)
    models.sort! { |a, b| b.updated_at <=> a.updated_at }
  end
end
