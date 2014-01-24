SubdomainFu.configure do |config|
  config.tld_sizes = {:development  => 1,
                      :test         => 0,
                      :staging      => 2,
                      :production   => 1} 
end
