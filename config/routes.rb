Gables::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  devise_for :users
  match '/admin/clear_cache' => 'application#clear_cache'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'


  constraints :subdomain => /^tablet/ do
    root  :to => 'tablet/properties#index'
    resources :properties, :only => [:index, :show, :edit], :as => "tablet_properties", :module => "tablet" do
      get 'manifest', :on => :member, :as => 'manifest'
      get "floorplans", :on => :member
      get "options", :on => :member
      post "email_brochure", :on => :member
      post "email_pdf", :on => :member
      resources :units, :only => [:index] do
        post "expire", :on => :collection
        get "nearby", :on => :collection
      end
    end
    resources :guests, :as => "tablet_guests", :module => "tablet"
    match 'samples' => "tablet/properties#samples"

    post 'sessions/create' => "tablet/sessions#create", :as => "tablet_create_sessions"
    put  'sessions' => "tablet/sessions#update"
    get  'sessions/status' => "tablet/sessions#status"
    post 'sessions/destroy' => "tablet/sessions#destroy"
    match "/find-guest" => "tablet/insite#find_guest"
    match "/guest-card" => "tablet/insite#guest_card"
    post "/submit-guest-card" => "tablet/insite#submit_guest_card"
  end

  constraints :subdomain => /urban/ do
    root :to => 'urban/home#index'
    match 'modal/contact'       => 'modal#contact'
    match 'modal/thankyou'      => 'modal#thankyou'
    match 'home/site_search'    => 'urban/home#site_search'
    match 'properties'          => 'urban/home#properties'
    match 'find/apartment/:id'  => 'urban/find#community'
    match 'find/where'  => 'urban/find#where'
    match 'modal/video'         => 'modal#video'
    match 'company/news/:id'    => 'company#news_show', :as => 'post'
    match 'company/news'        => 'company#news',      :as => 'posts'
    match ':section/p/:path'    => 'urban/pages#show', :as => 'urban_page',
          :constraints => {:section => /services|toplevel/}
  end

  constraints :subdomain => /gca/ do
    root  :to                   => 'gca/home#index'
    match 'gallery'             => 'gca/home#gallery'
    post 'contact'             => 'gca/home#contact'
    match 'modal/contact'       => 'modal#contact'
    match 'modal/thankyou'      => 'modal#thankyou'
    match 'find/where'          => 'gca/find#where'
    match 'find/listing/:id'  => 'gca/find#community', :as => 'listing'
    match 'find/walkscore/:id'  => 'find#walkscore', :as => 'walkscore'
    match 'modal/video'         => 'modal#video'
    match 'home/site_search'    => 'gca/home#site_search'
    post 'home/maintenance_request'  => 'gca/home#maintenance'
    post 'home/lease_request'  => 'gca/home#lease'
    match 'thank_you'           => 'gca/home#thank_you'
    match 'company/news/:id'    => 'company#news_show', :as => 'post'
    match 'company/news'        => 'company#news',      :as => 'posts'
    match 'equal_employment'    => 'home#equal_employment', :as => 'equal_employment'
    match ':section/p/:path'    => 'gca/pages#show', :as => 'gca_page',
          :constraints => {:section => /services|toplevel/}

    # Redirects
    match '/gca-living.aspx'                                => redirect('/toplevel/p/our_company')
    match '/gca-gablesservices.aspx'                        => redirect('/services/p/guest_services')
    match '/gca-careers.aspx'                               => redirect('http://gables.com/careers/p/careers_overview')
    match '/gca-contactus.aspx'                             => redirect('/toplevel/p/our_company')
    match '/home.aspx'                                      => redirect('/')
    match '/gca-living/gca-reservation.aspx'                => redirect('/contact')
    match '/gca-living/gca-furnishings.aspx'                => redirect('/gallery')
    match '/gca-living/gca-tour.aspx'                       => redirect('/gallery')
    match '/gca-living/gca-faq.aspx'                        => redirect('/services/p/how_it_works')
    match '/gca-gablesservices/gca-servicerequest.aspx'     => redirect('/services/p/guest_services')
    match '/gca-gablesservices/gca-testimonials.aspx'       => redirect('/services/p/how_it_works')
    match '/gca-gablesservices/gca-vacate.aspx'             => redirect('/services/p/guest_services')
    match '/gca-living/green-initiatives.aspx'             => redirect('http://gables.com/life/p/green_initiatives')

  end

  constraints :subdomain => /(?!gca|urban|tablet)/ do
    root :to => 'find#index'

    get "language" => "home#language"
    match 'contact'           => 'home#contact'
    match 'tablet'            => 'home#tablet'
    match 'equal_employment'  => 'home#equal_employment', :as => 'equal_employment'
    match 'privacy'           => 'home#privacy',          :as => 'privacy'
    match 'vaultware'         => 'home#vaultware',        :as => 'vaultware'
    match 'recent_searches'   => 'home#recent_searches',  :as => 'recent_searches'

    match ':section/p/:path'  => 'pages#show', :as => 'page',
          :constraints => {:section => /life|company|careers/}

    match   'find/apartment/:id'  => 'find#community', :as => 'property'
    match   'find/floorplan/:id'  => 'find#floorplan', :as => 'floorplan'
    match   'find/walkscore/:id'  => 'find#walkscore', :as => 'walkscore'

    match   'yelp/:id'  => 'find#yelp', :as => 'yelp'

    namespace 'find' do
      get   'where'
      post  'where'
      get   'comparison'
      get   'request_hold'
      get   'floorplans_serp'
    end

    namespace 'home' do
      get   'site_search'
      get   'empty'
    end

    namespace 'life' do
      get 'why_gables'
    end

    match 'company/news/:id'  => 'company#news_show', :as => 'post'
    match 'company/news'      => 'company#news',      :as => 'posts'

    namespace 'modal' do
      get   'thankyou'
      get   'contact'
      get   'video'
      get   'executive'
      post   'contact'
    end

    namespace 'sectionals' do
      get   'header'
      get   'footer'
    end

    namespace 'associates' do
      get   'show'
    end

    match   'associates/show/:id'  => 'associates#show', :as => 'associate'
    get 'sitemap.:format' => 'sitemap#show', :as => :sitemap, :constraints => {:format => 'xml'}

    match '/find/community/:any'                          => redirect('/find/apartment/%{any}')
    match '/aboutus.aspx'                                 => redirect('/life/p/why_gables')
    match '/aboutus/awards.aspx'                          => redirect('/company/news')
    match '/aboutus/community-service.aspx'               => redirect('/life/p/community_service')
    match '/aboutus/company-overview.aspx'                => redirect('/company/p/corporate_overview')
    match '/aboutus/company-philosophy.aspx'              => redirect('/life/p/why_gables')
    match '/aboutus/construction-and-development.aspx'    => redirect('/company/p/real_estate')
    match '/aboutus/copyright.aspx'                       => redirect('/privacy')
    match '/aboutus/gablesgreeninitiative.aspx'           => redirect('/life/p/green_initiatives')
    match '/aboutus/gablesgreeninitiative/earthday.aspx'  => redirect('/life/p/green_initiatives')
    match '/aboutus/gablesmessage.aspx'                   => redirect('/life/p/community_service')
    match '/aboutus/in-the-news.aspx'                     => redirect('/company/news')
    match '/aboutus/investmentstrategy.aspx'              => redirect('/company/p/real_estate')
    match '/aboutus/officers.aspx'                        => redirect('/company/p/corporate_executives')
    match '/aboutus/privacypolicy.aspx'	                  => redirect('/privacy')
    match '/aboutus/property-management.aspx'	            => redirect('/company/p/real_estate')
    match '/aboutus/sitemap.aspx'	                        => redirect('/')
    match '/aboutus/whotocontact.aspx'	                  => redirect('/company/p/corporate_contacts')
    match '/admin.:any'	                                  => redirect('/admin')
    match '/apartment-living/:any/:any'	                  => redirect('/life/p/why_gables')
    match '/around-town/:any/:any'                        => redirect('/')
    match '/careers.aspx'	                                => redirect('/careers/p/careers_overview')
    match '/carrers.aspx'	                                => redirect('/careers/p/careers_overview')
    match '/careers'                                      => redirect('/careers/p/search')
    match '/contactus.:any'	                              => redirect('/company/p/corporate_contacts')
    match '/gablesliving/:any'	                          => redirect('/life/p/why_gables')
    match '/gablesservices.:any'	                        => redirect('/company/p/corporate_overview')
    match '/gca-:any'	                                    => redirect('http://gca.gables.com/')
    match '/holiday2010/:any'                             => redirect('/')
    match '/home'	                                        => redirect('/')
    match '/index.:any'                                   => redirect('/')
    match '/intersource:any'                              => redirect('/')
    match '/jobs/:any'	                                  => redirect('/careers/p/careers_overview')
    match '/new:any'	                                    => redirect('/')
    match '/onlineleasing/:any'	                          => redirect('https://extra.gables.com/portal/')
    match '/portallogin.:any'                             => redirect('https://extra.gables.com/portal/')
    match '/post/:any'                                  	=> redirect('http://blog.gables.com/')
    match '/RequestConfirm.:any'	                        => redirect('/')
    match '/RequestPreQualify.:any'	                      => redirect('/')
    match '/RequestToHold.:any'                         	=> redirect('/')
    match '/RequestVIP.:any'                            	=> redirect('/')
    match '/Return.:any'	                                => redirect('/')
    match '/tumblelog/:any'	                              => redirect('http://blog.gables.com/')
    match '/UnitAvailability.:any'	                      => redirect('/')
    match '/UnitType.:any'	                              => redirect('/')
    match '/gca-living/green-initiatives.aspx'            => redirect('/life/p/green_initiatives')
    match '/green'            => redirect('/life/p/green_initiatives')
    match '/montecitoapartments'            => redirect('/montecito')

    # I can't think of a better way to do this than a catchall route -O.N.
    match ':path' => 'find#path', :constraints => {:path => /(?!admin|public|packages|ckeditor|assets).*/}
  end
end
