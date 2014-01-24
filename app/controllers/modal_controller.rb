class ModalController < ApplicationController
  layout 'modal'
  
  def contact
    @propertylist = Property.order('name ASC').map {|p| [p.name, p.id]}
    if !params[:property].blank?
      @property = Property.find(params[:property])
    end
    
    if !params[:urban_property].blank?
      @property = Urban::Property.find(params[:urban_property])
    end
    
    if params[:contact].blank?
      @contact = Contact.new
    else
      @contact = Contact.new(params[:contact])
      if @contact.valid?
        ContactMailer.contact(@contact).deliver if params[:a_comment_body].blank?
        redirect_to modal_thankyou_path
      end
    end
  end
  
  def thankyou
    
  end
  
  def video
    @video_id = params[:video_id]
  end
  
  def executive
    @executive = Executive.find(params[:id])
  end
end