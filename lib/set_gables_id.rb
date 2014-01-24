module SetGablesId
  def set_gables_id
    self["gables_id"] = "nonvw-#{SecureRandom.hex(20)}" if self["gables_id"].blank?
  end
end
