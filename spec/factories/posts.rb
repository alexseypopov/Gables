# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :post do |f|
  f.type "MyString"
  f.summary "MyText"
  f.text "MyText"
  f.title "MyString"
  f.featured false
  f.published_at "2011-06-06 10:28:01"
end
