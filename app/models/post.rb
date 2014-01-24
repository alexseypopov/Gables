class Post < ActiveRecord::Base
  mount_uploader :image, PostImageUploader

  validates_non_nilness_of :kind, :summary, :text, :title
  attr_accessible :featured, :kind, :image, :title, :text, :published, :published_at
  def to_param
    "#{id}-#{title.force_encoding('utf-8').to_url}"
  end

  # Used by rails_admin
  def kind_enum
    ['Award', 'NewsItem']
  end

  def self.published
    where(:published => true)
  end
  
  def self.featured
    where(:featured => true)
  end
end
