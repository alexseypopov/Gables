# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :block do |f|
  f.editable false
  f.title "MyString"
  f.context "MyText"
end
