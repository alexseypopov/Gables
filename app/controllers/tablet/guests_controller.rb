class Tablet::GuestsController < Tablet::ApplicationController
  # GET /tablet/guests
  # GET /tablet/guests.xml
  def index
    @all_guests = Tablet::Guest.where(:tablet_property_id => params[:insite_id]).includes(:insite_user)
    @my_guests = @all_guests.where(:tablet_insite_user_id => params[:key])

    render :json => {
      :my_guests  => @my_guests,
      :all_guests => @all_guests.as_json(:include => :insite_user)
    }
  end

  # GET /tablet/guests/1
  # GET /tablet/guests/1.xml
  def show
    @tablet_guest = Tablet::Guest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tablet_guest }
    end
  end

  # GET /tablet/guests/new
  # GET /tablet/guests/new.xml
  def new
    @tablet_guest = Tablet::Guest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tablet_guest }
    end
  end

  # GET /tablet/guests/1/edit
  def edit
    @tablet_guest = Tablet::Guest.find(params[:id])
  end

  # POST /tablet/guests
  # POST /tablet/guests.xml
  def create
    concat_phone_numbers params[:guest]
    @tablet_guest = Tablet::Guest.new(params[:guest])

    respond_to do |format|
      if @tablet_guest.save
        format.json  { render :json => @tablet_guest, :status => :created}
      else
        format.json  { render :json => @tablet_guest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tablet/guests/1
  # PUT /tablet/guests/1.xml
  def update
    concat_phone_numbers params[:guest]
    @tablet_guest = Tablet::Guest.find(params[:id])

    respond_to do |format|
      if @tablet_guest.update_attributes(params[:guest])
        format.json { render :json => @tablet_guest }
      else
        format.json  { render :json => @tablet_guest.errors, :status => :unprocessable_entity }
      end
    end
  end

end
