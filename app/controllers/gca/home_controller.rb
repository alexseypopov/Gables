class Gca::HomeController < Gca::ApplicationController
  layout 'gca/application'
  
  def index
    @promos = Gca::Promo.by_position_asc.limit(3)
    @sliders = Gca::HomeSlide.by_position_asc
    @footer_news = Post.featured.limit(3)
  end
  
  def gallery
    @section = 'services'
  end
  
  def contact
    if params[:gca_contact].blank?
      @contact = Gca::Contact.new(params[:contact] ? params[:contact] : nil)
    else
      @contact = Gca::Contact.new(params[:gca_contact])
      if @contact.valid?
        Gca::ContactMailer.deliver_contact @contact
        redirect_to '/thank_you'
      end
    end
  end
  
  def maintenance
    @maintenance = Gca::MaintenanceRequest.new(params[:maintenance])
    if @maintenance.valid?
      Gca::ContactMailer.deliver_maintenance @maintenance if params[:a_comment_body].blank?
      redirect_to '/thank_you'
    end
  end
  
  def lease
    @lease = Gca::LeaseRequest.new(params[:lease])
    if @lease.valid?
      Gca::ContactMailer.deliver_lease @lease if params[:a_comment_body].blank?
      redirect_to '/thank_you'
    end
  end
end
