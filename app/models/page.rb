class Page < ActiveRecord::Base
  mount_uploader :image, PageImageUploader

  validates_non_nilness_of  :title, :name
  validates_format_of       :path, :with => /\A[a-z\-_0-9]+\Z/i
  validates_uniqueness_of   :path

  ['main', 'side'].each do |pos|
  class_eval %{
    has_many  :page_#{pos}_blocks
    has_many  :#{pos}_blocks, :through => :page_#{pos}_blocks, :source => :page_block,
              :order => "page_#{pos}_blocks.position ASC"

    def #{pos}_block_ids=(ids)
      page_blocks = []

      ids.each_with_index do |id, index|
        pb = nil

        begin
          pb = Page#{pos.capitalize}Block.find_or_create_by_page_id_and_page_block_id(self.id, id)
        rescue ActiveRecord::RecordNotFound
          next
        end

        pb.update_attributes!(:position => index)
        page_blocks << pb
      end

      update_attributes(:page_#{pos}_blocks => page_blocks)
    end
  }
  end

  def self.published
    where(:published => true).order("position ASC")
  end
  
  def self.in_nav
    where(:published => true, :show_in_nav => true).order("position ASC")
  end

  def section
    raise 'Define section in the subclass'
  end
end
