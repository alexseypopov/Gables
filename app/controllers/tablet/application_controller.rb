class Tablet::ApplicationController < ActionController::Base
  rescue_from Tablet::PortalWebService::TokenExpiredError, :with => :token_expired

  private

  def concat_phone_numbers(hash = nil)
    hash ||= params
    %w(home work cell).each do |type|
      area = hash.delete "#{type}_area".to_sym
      exch = hash.delete "#{type}_exch".to_sym
      sln  = hash.delete "#{type}_sln".to_sym
      hash["#{type}_phone".to_sym] = "#{area}#{exch}#{sln}" if area && exch && sln
    end
  end

  def token_expired
    render :text => "Your token has expired", :status => :unauthorized
  end

end
