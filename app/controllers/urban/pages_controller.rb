class Urban::PagesController < ApplicationController
  layout 'urban/application'

  def show
    if params[:section] == 'toplevel'
      @page = Urban::ToplevelPage.published.find_by_path(params[:path], :include => [:main_blocks, :side_blocks])
    else
      @page = Urban::ServicesPage.published.find_by_path(params[:path], :include => [:main_blocks, :side_blocks])
    end
    raise ActiveRecord::RecordNotFound unless @page
    @section = @page.section

    case @section
      when 'services'
        @page_nav = Urban::ServicesPage.published
      when 'toplevel'
        @page_nav = Urban::ToplevelPage.published
    end
  rescue ActiveRecord::RecordNotFound
    error_404
  end
end
