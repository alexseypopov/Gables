# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :image do |f|
  f.imageable_id 1
  f.imageable_type "MyString"
  f.from_vaultware false
end
