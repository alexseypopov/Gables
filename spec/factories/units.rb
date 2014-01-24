# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :unit do |f|
  f.available_on Date.today
end
