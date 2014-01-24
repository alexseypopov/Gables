# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :page do |f|
  f.url_name "MyString"
  f.published false
  f.editable false
  f.nav_section "MyString"
  f.subtitle "MyString"
  f.title "MyString"
  f.name "MyString"
end
