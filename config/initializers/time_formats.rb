Date::DATE_FORMATS[:year] = "%Y"

class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime("%Y-%m-%d")
  end
end
