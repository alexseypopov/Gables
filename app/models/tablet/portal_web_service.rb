class Tablet::PortalWebService

  class TokenExpiredError < StandardError; end

  #http://rubyquicktips.com/post/4438542511/heredoc-and-indent
  Envelope = <<-XML.gsub(/^ {4}/, '')
    <?xml version="1.0" encoding="utf-8"?>
    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
      <soap12:Body>BODY</soap12:Body>
    </soap12:Envelope>
  XML

  def self.customer_search(options)
    options[:query] = "procTAB_CustomerSearch " +
    %w(first_name last_name home_phone work_phone cell_phone email).collect do |key|
      "'#{(options[key.to_sym] || "").gsub(/'/,"\\\\'")}'"
    end.join(",")
    parse query_return_data_set(options)
  end

  def self.get_guest_card(options)
    options[:query] = "procTAB_GetGuestCard '#{options[:cust_record_key]}','#{options[:prop_record_key]}'"
    parse(query_return_data_set(options)).first
  end

  def self.get_available_units(options)
    options[:query] = "procTAB_GetAvailableUnitsHere #{options[:prop_record_key]},\
      #{options[:beds] || 0},#{options[:baths] || 0},\
      #{options[:rent_min] || 0},#{options[:rent_max] || 0},'#{options[:date]}'"
    parse query_return_data_set(options)
  end

  def self.get_available_units_nearby(options)
    options[:query] = "procTAB_GetAvailableUnitsNearby #{options[:prop_record_key]}"
    parse query_return_data_set(options)
  end

  def self.get_available_options(options)
    options[:query] = "procTAB_GetAvailableOptions #{options[:prop_record_key]}"
    parse query_return_data_set(options)
  end

  def self.get_lro_pricing(options)
    options[:query] = "procTAB_GetLROPricing #{options[:punit_record_key]}"
    parse query_return_data_set(options)
  end

  def self.submit_guest_card(guest, options)
    parameters = %w( CUST_RecordKey CUST_NameLast CUST_NameFirst CUST_NameMI CUST_HomePhone CUST_WorkPhone CUST_CellPhone CUST_HEmail CUST_HStreet1 CUST_HStreet2 CUST_HZipCode CUST_EName CONT_RSOUR_RecordKey CONT_Target_Movein CONT_PUTYPE_RecordKey1 CONT_PUTYPE_RecordKey2 MaxRent CONT_MVIN_RecordKey CONT_Date CONT_Result CONT_FollowDate CONT_NoOccup CONT_TAB_GuestNames CONT_TAB_ReferralName CONT_TAB_ReferralFee CONT_TAB_ReferralType CONT_TAB_ReferralEscort CONT_Text CONT_NoLease_RecordKey CUST_EmailOptIn)
    query = parameters.collect do |param|
      "'#{guest.insite_data(param)}'"
    end
    query.insert(1,options[:user_id], options[:property_insite_id])
    options[:query] = "procTAB_SubmitGuestCard #{query.join(",")}"
    parse query_return_data_set(options)
  end

  private

  def self.parse(xml)
    xml.xpath("//Table").collect do |row|
      row.children.inject({}) { |hsh,tag| hsh[tag.name] = tag.inner_text; hsh }
    end
  end

  def self.query_return_data_set(options)
    puts options[:query]
    xml = request Envelope.gsub /BODY/, <<-XML
      <QueryReturnDataSet xmlns="http://tempuri.org/">
        <sToken>#{options[:token]}</sToken>
        <query>#{options[:query]}</query>
        <srctablename>NO_TABLE</srctablename>
      </QueryReturnDataSet>
    XML
  end

  def self.authenticate_insite_user(options)
    xml = request Envelope.gsub /BODY/, <<-XML
      <AuthenticateInsiteUser xmlns="http://tempuri.org/">
        <username>#{options[:username]}</username>
        <password>#{options[:password]}</password>
        <property>#{options[:property]}</property>
      </AuthenticateInsiteUser>
    XML
    {
      :token => xml.xpath("//TOKEN"          ).inner_text,
      :key   => xml.xpath("//USER_RecordKey" ).inner_text,
      :user  => xml.xpath("//USER_Name"      ).inner_text,
      :admin => xml.xpath("//Admin"          ).inner_text,
      :error => xml.xpath("//PROC_Error"     ).inner_text
    }
  end

  def self.request(xml)
    resp = CurbFu.post "https://#{Rails.configuration.portal_web_service_host}/portalwebservice/service.asmx" do |curl|
      curl.ssl_verify_host = curl.ssl_verify_peer = false
      curl.headers["Content-Type"] = "text/xml; charset=utf-8"
      curl.post_body = xml
    end
    noko_xml = Nokogiri::XML.parse resp.body
    raise TokenExpiredError if noko_xml.xpath("//TOKENSTATUS/Column1").inner_text == "TOKEN EXPIRED"
    noko_xml
  end

end
