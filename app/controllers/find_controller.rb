class FindController < ApplicationController
  before_filter :set_section, :except => [:where]
  caches_page :walkscore
  caches_action :community, :if => Proc.new { |c|
    c.params[:schedule].blank? && c.params[:schedule_success].blank?
  }
  caches_action :index
  caches_action :where, :cache_path => Proc.new { |c|
    c.params.delete_if{|k,v| v.blank? || k == 'utf8'}
  }, :if => Proc.new { |c|
    c.params.delete_if{|k,v| v.blank? || k == 'utf8'}.to_query.length < 150
  }

  def index
    @promos = Promo.by_position_asc
    @section = 'home'
    @footer_news = Post.featured.limit(3)
  end

  def where
    property = Property.published.where("name LIKE ?", params[:query]).first
    redirect_to property if property

    @section  = 'search'
    @query    = params[:state].blank? ? params[:query] : "#{params[:city]} #{Carmen::state_name(params[:state])}"
    @s = Search.new(
      :address            => @query,
      :beds               => params[:beds],
      :baths              => params[:baths],
      :rent_min           => params[:rent_min],
      :rent_max           => params[:rent_max],
      :allows_pets        => params[:pet_friendly],
      :property_amenities => params[:amenities],
      :unit_amenities     => params[:features],
      :availability       => params[:floorplans],
      :order_by           => params[:order]
    )

    if params[:mobile].nil?
      @properties = @s.properties.published.paginate(:per_page => 5, :page => params[:page] || 1)
    else
      @properties = @s.properties.published
    end

    if(@properties.count == 0)
      @regions = Region.where(['for_seo IS NULL OR for_seo = 0']).order('latitude DESC')
    else
      @p_search_amenities = PropertySearchAmenity.select_list
      @u_search_amenities = UnitSearchAmenity.select_list
      @region = Region.where("name LIKE ?", @query).first
      UserSearch.save_or_add(@query)
    end
  end

  def floorplans_serp
    @s = Search.new(
      :address            => @query,
      :beds               => params[:beds],
      :baths              => params[:baths],
      :rent_min           => params[:rent_min],
      :rent_max           => params[:rent_max],
      :allows_pets        => params[:pet_friendly],
      :property_amenities => params[:amenities],
      :unit_amenities     => params[:features],
      :availability       => params[:floorplans],
      :order_by           => params[:order]
    )

    @property = Property.find params[:property_id]
    render :layout => false
  end

  def path
    property = Property.find_by_path(params[:path])
    if property
      redirect_to property_path(property, :utm_source => params[:path], :utm_medium => 'Redirect', :utm_campaign => 'Redirect'), :status => :moved_permanently
    else
      error_404
    end
  end

  def comparison
    @section = 'community'
    @amenities = [
      "Business Center",
      "Child Care",
      "Club House",
      "Concierge",
      "Elevator",
      "Fitness Center",
      "Garage",
      "Gate",
      "Laundry",
      "Package Receiving",
      "Play Ground",
      "Pool",
      "Storage Space",
      "Tennis Court"]

    @features = [
      "Additional Storage",
      "Alarm",
      "Balcony",
      "Controlled Access",
      "Dish Washer",
      "Fireplace",
      "Garage",
      "Patio",
      "Washer",
      "Dryer",
      "WD Hookup"]


    if cookies[:comparisons].blank?
      redirect_to root_path, :alert => 'You have no properties to compare'
    else
      comparisons = JSON.parse cookies[:comparisons]
      @units = Unit.find(comparisons['units'].keys)
      @properties = Property.published.find(comparisons['communities'].keys)

      if(@units.length == 0 && @properties.length == 0)
        redirect_to root_path, :alert => 'You have no properties to compare'
      end
    end
  rescue ActiveRecord::RecordNotFound
    error_404
  end

  def community
    @section = 'community'
    @property = Property.published.includes(:urban_property).find params[:id]
    @shopping_etc = @property.urban_property && @property.urban_property.shopping_etc
    @green_categories = GreenCategory.order('position ASC')
    if params[:schedule].blank?
      @schedule = Schedule.new
    else
      @schedule = Schedule.new(params[:schedule])
      if @schedule.valid?
        @history = nil
        if cookies[:recently_viewed]
          viewed = cookies[:recently_viewed].split(',')
          @history = Floorplan.find(viewed, :order => 'bedrooms_count, bathrooms_count')
        end
        ContactMailer.schedule(@schedule, @property, @history).deliver if params[:a_comment_body].blank?
        redirect_to property_path(@property, :schedule_success => 1), :notice => 'Thank you! Your message was sent.'
      else
        flash[:alert] = 'Your message could not be sent!'
      end
    end
  rescue ActiveRecord::RecordNotFound
    error_404
  end

  def yelp
    if params[:id]
      ckey    = "zI_glmt04GqmclltX-XMnA"
      secret  = "H2aWXJqTl4akOphL1fF4iRCIuRA"
      token   = "XNxfPvtGXWx6WE1BonhLu_N1kew5IgPp"
      tsecret = "qwCmDDy4ZvLd91oMAZigDHH6HII"

      consumer = OAuth::Consumer.new(ckey, secret, :site => "http://api.yelp.com")
      access_token = OAuth::AccessToken.new( consumer, token, tsecret)

      render :json => access_token.get("/v2/business/#{params[:id]}").body
    else
      render :json => {:error => "No Yelp ID Found"}
    end
  end

  def floorplan
    @section = 'community'
    @floorplan  = Floorplan.find params[:id]
    @property   = @floorplan.property
    error_404 and return if !@property.published || (@property.use_propertysolutions_data? && !@floorplan.from_propertysolutions?) || (!@property.use_propertysolutions_data? && !@floorplan.from_vaultware? && @floorplan.from_propertysolutions?)
    @unit       = @floorplan.units.where(:id => params[:unit_id]).first
    @features   = @floorplan.amenities + (@unit ? @unit.amenities : [])
    recently_viewed(@floorplan)

    if params[:schedule].blank?
      @schedule = Schedule.new
    else
      @schedule = Schedule.new(params[:schedule])
      if @schedule.valid?
        @history = nil
        if cookies[:recently_viewed]
          viewed = cookies[:recently_viewed].split(',')
          @history = Floorplan.find(viewed, :order => 'bedrooms_count, bathrooms_count')
        end
        ContactMailer.schedule(@schedule, @floorplan.property, @history).deliver if params[:a_comment_body].blank?
        redirect_to floorplan_path(@floorplan, :schedule_success => 1), :notice => 'Thank you! Your message was sent.'
      end
    end
  rescue ActiveRecord::RecordNotFound
    error_404
  end

  def recently_viewed(floorplan)
    if cookies[:recently_viewed]
      viewed = cookies[:recently_viewed].split(',')
      if !viewed.include?(floorplan.id.to_s)
        viewed << floorplan.id.to_s
      end
      cookies[:recently_viewed] = { :value => viewed.uniq.join(','), :expires => 24.hours.from_now }
    else
      cookies[:recently_viewed] =  { :value => floorplan.id.to_s, :expires => 24.hours.from_now }
    end
    viewed = cookies[:recently_viewed].split(',')
    data_source_condition = if floorplan.use_propertysolutions_data?
      {:from_propertysolutions => true}
    elsif floorplan.from_vaultware?
      {:from_vaultware => true}
    else 
      {}
    end
    @recently_viewed = Floorplan.where({:id => viewed}.merge(data_source_condition)).limit(3).order('bedrooms_count, bathrooms_count')
  end

  def walkscore
    property = Property.find(params[:id])
    address = URI.escape("#{property.street} #{property.city} #{property.state}, #{property.zip}")
    url = "http://api.walkscore.com/score?address=#{address}&lat=#{property.latitude}&lon=#{property.longitude}&wsapikey=452849e006d5191372ad7268bd5a476c"
    xml = Nokogiri::XML(open(url))

    respond_to do |format|
      format.json  { render :json => {
        :walkscore => xml.xpath('ns:result/ns:walkscore', "ns" => "http://walkscore.com/2008/results").text,
        :link => xml.xpath('ns:result/ns:ws_link', "ns" => "http://walkscore.com/2008/results").text
      }}
    end
  rescue OpenURI::HTTPError
    render :json => 'Error reading from walkscore'
  end

  private
  def set_section
    @section = 'find'
  end
end
