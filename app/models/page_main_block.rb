class PageMainBlock < ActiveRecord::Base
  validates_non_nilness_of :position
  belongs_to  :page_block
  belongs_to  :page
end
