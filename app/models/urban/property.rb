class Urban::Property < ActiveRecord::Base
  has_many :images, :dependent => :destroy, :order => "urban_images.position ASC",
                    :class_name => "Urban::Image"
  belongs_to :property
  mount_uploader :full_brochure, Urban::BrochureUploader
  validates_non_nilness_of  :name
  attr_accessible :name, :position, :phone, :street, :city, :state, :zip,
                  :email, :short_description, :long_description, :opening_year,
                  :apartments_count, :square_footage, :site_url, :map_url, :shopping_etc,
                  :image_ids, :full_brochure
  def state_enum
    Carmen::state_codes('US')
  end

  def rails_admin_label
    "#{id} #{name}"
  end

  def address
    "#{street}, #{city}, #{state} #{zip}"
  end

  def to_param
    "#{id}-#{name.to_url}"
  end

  def image_ids=(ids)
    is = []

    ids.each_with_index do |id, index|
      image = nil

      begin
        image = Urban::Image.find(id)
      rescue ActiveRecord::RecordNotFound
        next
      end

      image.update_attributes!(:position => index)
      is << image
    end

    update_attributes(:images => is)
  end
  
  def self.seed
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Located at the intersection of Kirby and Westheimer, West Ave is the first pedestiran friendly, mixed-use development in Houstn\'s Inner Loop',
                                          :shopping_etc           => '',
                                          :opening_year           => '2010',
                                          :apartments_count       => '398',
                                          :square_footage         => '195000',
                                          :site_url               => 'http://www.westaveriveroaks.com',
                                          :map_url                => 'http://bit.ly/pLvgic',
                                          :name                   => 'West Ave',
                                          :phone                  => '713.595.9500',
                                          :street                 => '2800 Kirby Drive',
                                          :city                   => 'Houston',
                                          :state                  => 'TX',
                                          :zip                    => '77098',
                                          :email                  => 'bpalka@page-partners.com')
                                          
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Park Plaza features of the the only new lakefront retail opportunities in downtown Austin, offering amazingviews of Town lake and the city\'s skyline.',
                                          :shopping_etc           => '<ul><li><a href="http://lukeslocker.com">Luke\'s Locker</a> | 512.482.8676</li></ul>',
                                          :opening_year           => '2010',
                                          :apartments_count       => '292',
                                          :square_footage         => '10854',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/nwn03f',
                                          :name                   => 'Park Plaza',
                                          :phone                  => '512.482.8676',
                                          :street                 => '115 Sandra Muraida Way',
                                          :city                   => 'Austin',
                                          :state                  => 'TX',
                                          :zip                    => '78703',
                                          :email                  => 'sue@platformre.com')
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Located at 5th and Pressler, Gables Pressler caters to the affluent surrounding neighborhood offering dining, shopping and service retail.',
                                          :shopping_etc           => '<ul><li><a href="http://avantsalon.com">Avant Salon</a> | 512.472.6357</li><li><a href="http://purbikramyoga.com">Pure Bikram Yoga</a> | 512.499.0490</li><li><a href="http://tntgrill.com">TNT</a> | 512.436.8226</li></ul>',
                                          :opening_year           => '2009',
                                          :apartments_count       => '168',
                                          :square_footage         => '26400',
                                          :site_url               => '',
                                          :map_url                => '',
                                          :name                   => 'Pressler',
                                          :phone                  => '512.473.0400',
                                          :street                 => 'Pressler Street',
                                          :city                   => 'Austin',
                                          :state                  => 'TX',
                                          :zip                    => '78703',
                                          :email                  => 'sue@platformre.com')
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'With an award winning design, this new destination for Uptown offers inviting retail and dinging options with large terrace seating.',
                                          :shopping_etc           => '<ul><li><a href="http://naansushi.com">Naan Sushi</a> | 214.772.6399</li><li><a href="http://foodboutique.com">The Food Boutique</a></li></ul>',
                                          :opening_year           => '2008',
                                          :apartments_count       => '550',
                                          :square_footage         => '15000',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/pxcfbR',
                                          :name                   => 'Villa Rosa',
                                          :phone                  => '214.252.2660',
                                          :street                 => '2650 Cedar Springs Road',
                                          :city                   => 'Dallas',
                                          :state                  => 'TX',
                                          :zip                    => '75201',
                                          :email                  => 'retail@gables.com') 
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Dallas\' newest high-rise in the heart of Uptown, Park 17 offers a prestigious address adjacent to Downtown, The Arts District and American Airlines Center.',
                                          :shopping_etc           => '',
                                          :opening_year           => '2010',
                                          :apartments_count       => '292',
                                          :square_footage         => '6000',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/qSfWx2',
                                          :name                   => 'Park 17',
                                          :phone                  => '',
                                          :street                 => '1700 Cedar Springs Road',
                                          :city                   => 'Dallas',
                                          :state                  => 'TX',
                                          :zip                    => '75201',
                                          :email                  => '')
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'A high-rise tower located in the heart of Uptown, Dallas\' mecca for shopping, dining and entertainment.',
                                          :shopping_etc           => '<ul><li><a href="http://frankiesbar.com">Frankie\'s Sports Bar</a> | 214.999.8932</li><li><a href="http://salonpompeo.com">Salon Pompeo</a> | 214.979.0440</li></ul>',
                                          :opening_year           => '1986',
                                          :apartments_count       => '196',
                                          :square_footage         => '15400',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/qb6S16',
                                          :name                   => 'Uptown Tower',
                                          :phone                  => '214.252.2660',
                                          :street                 => '3227 McKinney Avenue',
                                          :city                   => 'Dallas',
                                          :state                  => 'TX',
                                          :zip                    => '75204',
                                          :email                  => 'retail@gables.com')
                                                                                                                     
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Located in the heart of Wilton Manors, Wilton Park offers shopping and living options in a bustling entertainment district.',
                                          :shopping_etc           => '',
                                          :opening_year           => '2010',
                                          :apartments_count       => '145',
                                          :square_footage         => '17000',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/qYiP00',
                                          :name                   => 'Wilton Park',
                                          :phone                  => '',
                                          :street                 => '513 NE 21st Court #120',
                                          :city                   => 'Wilton Manors',
                                          :state                  => 'FL',
                                          :zip                    => '33305',
                                          :email                  => '') 
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'The new downtown for the thriving Las Colinas, Water Street is destined to become the most significant waterfront development in Texas.',
                                          :shopping_etc           => '',
                                          :opening_year           => '2014',
                                          :apartments_count       => '450',
                                          :square_footage         => '250000',
                                          :site_url               => '',
                                          :map_url                => 'http://www.waterstreetlascolinas.com',
                                          :name                   => 'Water Street',
                                          :phone                  => '214.252.2656',
                                          :street                 => '',
                                          :city                   => 'Las Colinas',
                                          :state                  => '',
                                          :zip                    => '',
                                          :email                  => 'retail@gables.com') 
                                          
    Urban::Property.create_idempotently!( :short_description      => 'Overview',
                                          :long_description       => 'Located in Coral Gables, 4585 Ponce is an ideal retail location serving the educated and affluent professionals of Miami-Dade County. The property is located at the corner of one the heaviest thoroughfares in Coral Gable for maximum visibility.',
                                          :shopping_etc           => '',
                                          :opening_year           => '',
                                          :apartments_count       => '',
                                          :square_footage         => '30125',
                                          :site_url               => '',
                                          :map_url                => 'http://bit.ly/qgBhXw',
                                          :name                   => '4585 Ponce',
                                          :phone                  => '214.252.2666',
                                          :street                 => '4585 Ponce De Leon',
                                          :city                   => 'Coral Gables',
                                          :state                  => 'FL',
                                          :zip                    => '33146',
                                          :email                  => 'retail@gables.com')                                                                                                                                                                                                                       
  end
  
private
  def self.create_idempotently!(options={})
    unless Urban::Property.where(:name => options[:name]).exists?
      Urban::Property.create!(options)
    end
  end
end





