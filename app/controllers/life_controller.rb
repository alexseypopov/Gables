class LifeController < ApplicationController
  before_filter :set_section
  
  def why_gables
    @page = 'why'
  end
  
  private
  def set_section
    @section = 'life'
  end
end