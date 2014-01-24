class PagesController < ApplicationController
  def show
    @page = Page.published.find_by_path(params[:path], :include => [:main_blocks, :side_blocks])
    raise ActiveRecord::RecordNotFound unless @page
    @section = @page.section

    if @page.path == 'why_gables'
      @slides = LifeSlide.by_position_asc
    end

    case @section
      when 'life'
        @page_nav = LifePage.in_nav 
      when 'company'
        @page_nav = CompanyPage.in_nav 
      when 'careers'
        @page_nav = CareerPage.in_nav
    end
  end
end
