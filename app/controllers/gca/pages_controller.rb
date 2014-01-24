class Gca::PagesController < Gca::ApplicationController
  layout 'gca/application'

  def show
    if params[:section] == 'toplevel'
      @page = Gca::ToplevelPage.published.find_by_path(params[:path], :include => [:main_blocks, :side_blocks])
    else
      @page = Gca::ServicesPage.published.find_by_path(params[:path], :include => [:main_blocks, :side_blocks])
    end
    raise ActiveRecord::RecordNotFound unless @page
    @section = @page.section

    case @section
      when 'services'
        @page_nav = Gca::ServicesPage.in_nav
      when 'toplevel'
        @page_nav = nil
    end
  rescue ActiveRecord::RecordNotFound
    error_404
  end
end
