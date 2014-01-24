class CareersController < ApplicationController
  before_filter :set_section
  
  def community_jobs
    @page = 'community_jobs'
  end
  
  def search
    @page = 'job_search'
  end
  
  private
  def set_section
    @section = 'careers'
  end
end