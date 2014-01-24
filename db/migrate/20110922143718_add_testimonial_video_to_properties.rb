class AddTestimonialVideoToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :testimonial_video, :string
  end

  def self.down
    remove_column :properties, :testimonial_video
  end
end
