class CompanyPage < Page
  attr_accessible :published, :show_in_nav, :path, :name,
                  :subtitle, :title, :description, :position, :image, :main_block_ids, :side_block_ids,
  def section
    'company'
  end
end
