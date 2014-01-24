class CareerPage < Page
  attr_accessible :path, :name, :subtitle, :title, :description, :position, :image, :main_block_ids, :side_block_ids,
                  :published, :show_in_nav

  def section
    'careers'
  end
end
