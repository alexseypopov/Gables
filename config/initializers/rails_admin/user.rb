RailsAdmin.config do |config|
  config.model User do

    list do
      field :id
      field :email
      field :sign_in_count
      field :current_sign_in_at
      field :last_sign_in_at
      field :current_sign_in_ip
      field :last_sign_in_ip
      field :reset_password_token
      field :reset_password_sent_at
      field :remember_created_at
      field :confirmation_token
      field :confirmed_at
      field :confirmation_sent_at
      field :created_at
      field :updated_at
      field :administers_residential
      field :administers_gca
      field :administers_urban
    end

    edit do
      field :email
      field :password
      field :password_confirmation
      field :administers_residential
      field :administers_gca
      field :administers_urban
    end

    create do
      field :email
      field :password
      field :password_confirmation
      field :administers_residential
      field :administers_gca
      field :administers_urban
    end
  end
end
