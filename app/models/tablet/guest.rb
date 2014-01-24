class Tablet::Guest < ActiveRecord::Base
  default_scope where("`tablet_guests`.`inactive` IS NULL or `tablet_guests`.`inactive` in (0)")
  belongs_to :insite_user, :foreign_key => "tablet_insite_user_id"

  serialize :preferred_floorplans

  def self.from_insite(options = {})
    new({
      :insite_id      => options["CUST_RecordKey"],
      :first_name     => options["CUST_NameFirst"],
      :last_name      => options["CUST_NameLast"],
      :middle_initial => options["CUST_NameMI"],
      :email          => options["CUST_HEmail"],
      :home_phone     => options["CUST_HomePhone"],
      :cell_phone     => options["CUST_CellPhone"],
      :work_phone     => options["CUST_WorkPhone"],
      :address_line1  => options["CUST_HStreet1"],
      :address_line2  => options["CUST_HStreet2"],
      :zip            => options["CUST_HZipCodeText"],
      :employer_name  => options["CUST_EName"],
      :property_name  => options["PropName"],
      :status         => options["LEASE_Status"],
      :move_in_date   => options["CONT_Target_Movein"],
      :num_occupants  => options["CONT_NoOccup"],
      :notes          => options["CONT_Text"],

      :preferred_unit_type1  => options["CONT_PUTYPE_RecordKey1"],
      :preferred_unit_type2  => options["CONT_PUTYPE_RecordKey2"],
      :tablet_lead_source_id => options["CONT_RSOUR_RecordKey"],
      :tablet_rent_range_id  => options["CONT_RRNG_RecordKey"],
      :tablet_leasing_reason_id  => options["CONT_MVIN_RecordKey"],
    }) if options
  end

  def preferred_floorplans
    self.attributes["preferred_floorplans"] || []
  end

  def as_json(options={})
    super.merge("created_at" => (created_at && created_at.strftime("%m/%d/%Y")))
  end

  def notes
    [notes_likes,notes_dislikes,notes_remarks,notes_hotbuttons].join(";")
  end

  def insite_data(field)
    method = Tablet::Guest::InsiteMapping.invert[field]
    data = if respond_to? "insite_#{method}".to_sym
      send "insite_#{method}".to_sym
    else
      send method
    end
    return data.to_date if data.is_a? ActiveSupport::TimeWithZone
    data
  end

  def insite_insite_id
    insite_id || 0
  end

  def insite_preferred_unit_type1
    preferred_unit_type1 || 0
  end

  def insite_preferred_unit_type2
    preferred_unit_type2 || 0
  end

  def insite_follow_up_required
    follow_up_required ? "F" : "N"
  end

  def insite_escorted
    escorted ? "Y" : "N"
  end

  def insite_email_optin
    email_optin ? "Y" : "N"
  end

  def insite_referral_type
    # B for broker, R for resident, nil for none
    case tablet_lead_source_id
    when 4 then "B"
    when 10 then "R"
    end
  end

  InsiteMapping = {
    :insite_id      => "CUST_RecordKey",
    :first_name     => "CUST_NameFirst",
    :last_name      => "CUST_NameLast",
    :middle_initial => "CUST_NameMI",
    :email          => "CUST_HEmail",
    :home_phone     => "CUST_HomePhone",
    :work_phone     => "CUST_WorkPhone",
    :cell_phone     => "CUST_CellPhone",
    :address_line1  => "CUST_HStreet1",
    :address_line2  => "CUST_HStreet2",
    :zip            => "CUST_HZipCode",
    :employer_name  => "CUST_EName",
    :move_in_date   => "CONT_Target_Movein",
    :num_occupants  => "CONT_NoOccup",
    :notes          => "CONT_Text",

    :preferred_unit_type1         => "CONT_PUTYPE_RecordKey1",
    :preferred_unit_type2         => "CONT_PUTYPE_RecordKey2",
    :tablet_lead_source_id        => "CONT_RSOUR_RecordKey",
    :tablet_leasing_reason_id     => "CONT_MVIN_RecordKey",
    :tablet_not_leasing_reason_id => "CONT_NoLease_RecordKey",

    :created_at         => "CONT_Date",
    :follow_up_required => "CONT_Result",
    :follow_up_date     => "CONT_FollowDate",
    :guest_names        => "CONT_TAB_GuestNames",
    :referral_name      => "CONT_TAB_ReferralName",
    :referral_fee       => "CONT_TAB_ReferralFee",
    :referral_type      => "CONT_TAB_ReferralType", ###CHANGEME
    :escorted           => "CONT_TAB_ReferralEscort",
    :email_optin        => "CUST_EmailOptIn",
    :max_rent           => "MaxRent"
  }

end

