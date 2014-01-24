class Ability
  include CanCan::Ability

  def initialize(user)
    user = user || User.new
    can :access, :rails_admin
    can :dashboard
    can :read, PageBlock

    if user.administers_residential
      can :manage, [User, Property, Floorplan, Amenity, Special, Region, Image, Unit, Promo,
                    PropertySearchAmenity, UnitSearchAmenity, Block, CareerPage, SitePlan, Setting,
                    CompanyPage, LifePage, Post, HomeSlide, LifeSlide, Associate, Executive, SeoRegion, GreenInitiative, GreenCategory]
    end

    if user.administers_gca
      can :manage, [Gca::Block, Gca::HomeSlide, Gca::ServicesPage, Gca::ToplevelPage, Gca::Promo, Gca::Region, Gca::PropertyRegion, Gca::Property]
    end

    if user.administers_urban
      can :manage, [Urban::Block, Urban::HomeSlide, Urban::ServicesPage, Urban::ToplevelPage,
                    Urban::Promo, Urban::Property, Urban::Image]
    end
  end
end
