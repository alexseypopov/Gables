class Urban::FindController < ApplicationController
  layout 'urban/application'
  
  def community
    @section = 'properties'
    @property = Urban::Property.find params[:id]
  rescue ActiveRecord::RecordNotFound
    error_404
  end
  
  
  def where
    @section = 'properties'
    
    @properties = Urban::Property.where("street like '#{params[:query]}' or city like '#{params[:query]}' or state like '#{params[:query]}' or zip like '#{params[:query]}'").order('position ASC')
    @cities = Urban::Property.select("DISTINCT(city)").order('city').map(&:city)
  end
  
  
end