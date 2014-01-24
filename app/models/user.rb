class User < ActiveRecord::Base
  validates_non_nilness_of :email
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :administers_residential, :administers_gca, :administers_urban, :remember_me

  def self.seed
    User.create_idempotently!(:email                    => 'vishi.gondi@digitalscientists.com',
                              :password                 => 'scientists',
                              :password_confirmation    => 'scientists',
                              :administers_residential  => true)

    User.create_idempotently!(:email                  => 'vishi.gondi+gca@digitalscientists.com',
                              :password               => 'scientists',
                              :password_confirmation  => 'scientists',
                              :administers_gca        => true)

    User.create_idempotently!(:email                  => 'vishi.gondi+urban@digitalscientists.com',
                              :password               => 'scientists',
                              :password_confirmation  => 'scientists',
                              :administers_urban      => true)
  end

private
  def self.create_idempotently!(options={})
    unless User.where(:email => options[:email]).exists?
      User.create!(options)
    end
  end
end
