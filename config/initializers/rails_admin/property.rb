  RailsAdmin.config do |config|
    config.model Property do
      object_label_method { :rails_admin_label }

      list do
        field :id
        field :name
        field :from_vaultware
        field :from_propertysolutions
        field :use_propertysolutions_data
        field :published
        field :featured

        field :gables_id do
          label "Gables id"
        end

        field :short_description
        field :long_description
        field :region_id
        field :allows_dogs
        field :allows_cats
        field :pet_policy
        field :cat_policy
        field :dog_policy
        field :phone
        field :street
        field :city
        field :state
        field :zip
        field :created_at
        field :updated_at
        field :latitude
        field :longitude
        field :images
        field :monday_hours
        field :tuesday_hours
        field :wednesday_hours
        field :thursday_hours
        field :friday_hours
        field :saturday_hours
        field :sunday_hours
        field :show_walkscore
        field :show_ratings
        field :contact_form_email
        field :yelp_id
        field :video_id
        field :calendar_url
        field :blog_url
        field :facebook_url
        field :twitter_url
        field :community_programs
        field :shopping_and_dining
        field :uses_chat
        field :path
      end

      edit do
        field :published
        field :featured
        field :use_propertysolutions_data do
          label "Use Property Solutions data"
          visible { bindings[:object].from_propertysolutions? }
        end

        field :name do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :pet_policy do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :allows_dogs do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :dog_policy do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :allows_cats do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :cat_policy do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :short_description do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :long_description do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :images do
          help "Start typing to see all matching items"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
          orderable true
        end

        field :phone do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :street do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :city do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :state, :enum do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :zip do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :monday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :tuesday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :wednesday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :thursday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :friday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :saturday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :sunday_hours do
          help "Required: e.g. 9:00AM - 5:00PM"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :region_id

        field :floorplans do
          help "Start typing to see all matching items"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :specials do
          help "Start typing to see all matching items"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :amenities do
          help "Start typing to see all matching items"
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :show_walkscore,  :boolean
        field :show_ratings,    :boolean

        field :contact_form_email do
          visible { not (bindings[:object].from_vaultware or bindings[:object].from_propertysolutions) }
        end

        field :yelp_id do
          label "Yelp id"
          help "e.g. in http://www.yelp.com/biz/quinones, the id is 'quinones'"
        end

        field :google_id do
          label "Google+ id"
        end

        field :video_id do
          label "Video id"
          help "e.g. in http://www.youtube.com/watch?v=xF8MAE, the id is 'xF8MAE'"
        end

        field :testimonial_video do
          label "Testimonial Video id"
          help "e.g. in http://www.youtube.com/watch?v=xF8MAE, the id is 'xF8MAE'"
        end

        field :blog_url
        field :calendar_url
        field :facebook_url
        field :twitter_url
        field :pinterest_url
        field :green_initiatives
        field :community_programs
        field :shopping_and_dining, :text do
          ckeditor true
        end
        field :uses_chat

        field :full_brochure do
          label "Floorplan Brochure PDF"
        end

        field :short_brochure do
          label  "Community Brochure PDF"
        end

        field :building_specifications_file do
          label  "Building Specifications PDF"
        end

        field :sor_policy do
          label "SOR Policy URL"
        end

        field :lease_briefs do
          label  "Lease Briefs PDF"
        end

        field :resident_brochure do
          label  "Resident Brochure PDF"
        end

        field :building_specifications, :text do
          ckeditor true
        end

        field :path do
          help "Required e.g. in http://www.gables.com/chevychase, the path is 'chevychase'"
        end

        field :urban_property

        field :resident_reviews_id do
          label 'Resident Reviews ID'
        end
      end
    end
  end
