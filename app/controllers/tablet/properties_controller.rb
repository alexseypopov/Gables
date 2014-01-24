class Tablet::PropertiesController < ActionController::Base
  layout 'tablet/application'

  rescue_from Tablet::PortalWebService::TokenExpiredError, :with => :token_expired

  def index
    @properties = ::Property.where(:insite_id => [422, 467, 492, 503, 498, 200])
  end

  def show
    @property = ::Property.published.includes(:green_initiatives => :green_category).find params[:id]
    @tablet_property = Tablet::Property.find_by_id(@property.insite_id)
    @floorplans = @property.floorplans.includes(:images, :amenities, :units => :amenities)
    @green_categories = @property.green_initiatives.inject({}) do |hsh,initiative|
      (hsh[initiative.green_category] ||= []) << initiative
      hsh
    end
    @living_guarantees   = Block.where(:title => "Living Guarantees").first
    @connection_services = Block.where(:title => "Connection Services").first
    @connection_services_url = Block.where(:title => "Connection Services URL").first
    @furnished_apartments = Block.where(:title => "Furnished Apartments").first
    @take_home_benchmarks = Block.where(:title => "Tablet Take Home Benchmarks").first
    @images = @property.images(:order => 'position ASC')
    @lead_sources = Tablet::LeadSource.where(:tablet_property_id => @property.insite_id)
  end

  def floorplans
    @property = ::Property.published.joins(:floorplans).find params[:id]
    @floorplans = @property.floorplans.includes(:images, :units, :amenities)

    respond_to do |format|
      format.html { }
      format.json { render :json => @floorplans.as_json(:include => [:images, :units, :amenities]) }
    end
  end

  def options
    options = Tablet::PortalWebService.get_available_options(
      :prop_record_key => params[:insite_id],
      :token           => params[:token]
    )
    if options.first["PROC_Error"] == "NONE"
      render :json => options.group_by{|u| u["Option_x0020_Type"]}
    else
      render :json => "", :status => 204
    end
  end

  def samples
    render "tablet/samples"
  end

  def email_brochure
    @property = ::Property.find(params[:id])
    method = case params[:type]
      when "floorplans"     then :full_brochure
      when "community"      then :short_brochure
      when "specifications" then :building_specifications_file
    end
    if method
      Tablet::PropertyMailer.email_brochure(
        params[:email],@property.send(method),@property.name
      ).deliver
    end
    render :text => "hello"
  end

  def email_pdf
    proc = fork do
      html = "<doctype html><html><body>#{params[:html]}</body></html>"
      kit = PDFKit.new(html, page_size: 'Letter')
      kit.stylesheets << 'public/stylesheets/tablet/print.css'

      # Get an inline PDF
      pdf = kit.to_pdf

      Tablet::PropertyMailer.email_pdf(
        params[:email],pdf,params[:name]
      ).deliver
    end
    Process.detach(proc)
    head :ok
  end

  def manifest
    @property = ::Property.find(params[:id])

    render :action => "manifest", :content_type => "text/cache-manifest", :layout => false
  end

  private

  def token_expired
    render :text => "Your token has expired", :status => :unauthorized
  end

end
