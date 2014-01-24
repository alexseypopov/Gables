class CompanyController < ApplicationController
  before_filter :set_section
  
  def news
    @posts = Post.published.where(['kind LIKE ?', params[:type] ? params[:type] : '%']).order("published_at DESC").paginate(:per_page => 5, :page => params[:page] || 1)
  end

  def news_show
    @post = Post.published.find params[:id]
  rescue ActiveRecord::RecordNotFound
    error_404
  end
  
  private
  def set_section
    @section = 'company'
  end
end