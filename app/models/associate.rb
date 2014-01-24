class Associate < ActiveRecord::Base
  mount_uploader :image, AssociateImageUploader
  validates_non_nilness_of :name, :title

  def rails_admin_label
    "#{id} #{name}"
  end

  def self.featured
    where(:featured => true)
  end
  
  def self.states
    [
      ["Arizona",         "-12901-"],
      ["California",      "-12906-"],
      ["Florida",         "-12910-"],
      ["Georgia",         "-12911-"],
      ["Illinois",        "-12914-"],
      ["Maryland",        "-12921-"],
      ["Massachusetts",   "-12922-"],
      ["New Jersey",      "-12931-"],
      ["New York",        "-12933-"],
      ["Tennessee",       "-12943-"],
      ["Texas",           "-12944-"],
      ["Virginia",        "-12947-"],
      ["Washington",      "-12948-"],
      ["Washington, DC",  "-12949-"]
    ]
  end
  
  def self.departments
    [
      ["Accounting",                "8713"],
      ["Asset Management",          "14288"],
      ["Brokerage",                 "12305"],
      ["Capex",                     "12308"],
      ["Construction",              "12307"],
      ["Corporate Accommodations",  "12306"],
      ["Development",               "12309"],
      ["Executive",                 "12310"],
      ["Human Resources",           "8725"],
      ["Information Technology",    "8730"],
      ["Leasing Office",            "16165"],
      ["Marketing",                 "14297"],
      ["Operations",                "12311"],
      ["Property - Onsite",         "12312"],
      ["Retail",                    "12313"],
      ["Service/Maintenance Team",  "16166"],
      ["Training (L&amp;D)",        "12314"]
    ]
  end
end
