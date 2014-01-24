Gables::Application.configure do
  config.cache_classes                      = true
  config.consider_all_requests_local        = false
  config.action_controller.perform_caching  = true
  config.action_dispatch.x_sendfile_header  = "X-Sendfile"
  config.serve_static_assets                = false
  config.i18n.fallbacks                     = true
  config.active_support.deprecation         = :notify
  config.action_mailer.default_url_options  = { :host => 'ec2-50-17-194-39.compute-1.amazonaws.com' }
  config.action_mailer.delivery_method      = :sendmail
  config.portal_web_service_host = "extradev.gables.com:81"
  #config.assets.precompile +=
  #    Dir["#{Rails.root}/app/assets/stylesheets/mobile/*.*"].collect {|s| "mobile/" + File.basename(s).gsub(/.scss|.sass/, '') }
  config.x.property_solutions.domain = 'gables'
  config.x.property_solutions.username = 'aparlin'
  config.x.property_solutions.password = 'gables2013'
end
