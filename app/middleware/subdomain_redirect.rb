#http://gistflow.com/posts/713-redirect-mobile-user-agent-to-subdomain-as-rack-middleware

class SubdomainRedirect
  
  # we could set these values with the options array if needed
  def initialize(app, options = {})
    @app = app
    @wurfl = WURFL.new 'db/wurfl-2.3.4.gz'
    @subdomain_mobile   = 'mobile'
    @subdomain_full     = ''
  end
  
  def call(env)
    # we need ActionDispatch::Request for cookie access
    request = ActionDispatch::Request.new(env)

    if request.GET.has_key?('pinmobile')
      request.cookie_jar.permanent[:site_pref] = @subdomain_mobile
      return redirect_to_mobile_site(request) unless mobile_site?(request)
    elsif request.GET.has_key?('pindesktop')
      request.cookie_jar.permanent[:site_pref] = @subdomain_full
      return redirect_to_full_site(request) unless full_site?(request)
    end

    wurfl_device = @wurfl[request.user_agent]
    mobile_device = wurfl_device && !wurfl_device.is_tablet

    if !mobile_site?(request) && (prefers_mobile_site?(request) || (mobile_device && !prefers_full_site?(request)))
      return redirect_to_mobile_site(request)
    end

    if !full_site?(request) && (prefers_full_site?(request) || (!mobile_device && !prefers_mobile_site?(request)))
      return redirect_to_full_site(request)
    end
    
    @app.call(env)
  end

  def redirect_to_mobile_site(request)
    [301, {"Location" => request.url.sub(/\/\/(#{@subdomain_full}\.)?/i, "//#{@subdomain_mobile}.")}, self]
  end

  def redirect_to_full_site(request)
    [301, {"Location" => request.url.sub(/\/\/(#{@subdomain_mobile}\.)?/i, "//#{@subdomain_full}")}, self]
  end  

  def prefers_mobile_site?(request)
    request.cookie_jar[:site_pref] == @subdomain_mobile
  end

  def prefers_full_site?(request)
    request.cookie_jar[:site_pref] == @subdomain_full
  end

  def full_site?(request)
    request.host !~ /^#{@subdomain_mobile}/i
  end

  def mobile_site?(request)
    request.host =~ /^#{@subdomain_mobile}/i 
  end

  def each(&block)
  end

end