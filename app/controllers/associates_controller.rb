class AssociatesController < ApplicationController
  before_filter :set_section
  
  def show
    @associate = Associate.find(params[:id])
    @associates = Associate.all
  end
  
  private
  def set_section
    @section = 'careers'
  end
end