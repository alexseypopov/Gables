class PageBlock < ActiveRecord::Base
  validates_non_nilness_of :editable, :title, :content
  attr_accessible :title, :content, :page_id, :page_block_id
  def rails_admin_label
    "#{id} #{title}"
  end
end
