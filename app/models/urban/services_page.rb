class Urban::ServicesPage < Urban::Page
  attr_accessible :published, :show_in_nav, :path, :name, :subtitle,
                  :title, :description, :position, :image,
                  :side_block_ids, :main_block_ids
  def section
    'services'
  end
end
