# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user_search do |f|
  f.query "MyString"
  f.count 1
end
