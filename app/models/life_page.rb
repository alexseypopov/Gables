class LifePage < Page
  attr_accessible :name, :title, :description, :image, :published, :show_in_nav,
                  :path, :subtitle, :position
  def section
    'life'
  end
end
