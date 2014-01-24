class Cache
  def self.expire
    puts "[#{DateTime.now}] Clearing cache"
    expire_pages
    expire_actions_and_fragments
  end

  def self.expire_pages
    FileUtils.rm_rf Dir.glob(Rails.root.join('public/find/*')), :secure => true
    FileUtils.rm    Rails.root.join('public/index.html'), :force => true
  end

  def self.expire_actions_and_fragments
    FileUtils.rm_rf Dir.glob(Rails.root.join('tmp/cache/*')), :secure => true
  end

  def self.prime
    props = Property.select(["DISTINCT(city)", :state]).published
    states = props.map(&:state).uniq.map{|state| Carmen::state_name(state) }
    cities = props.map(&:city).uniq
    regions = Region.select("DISTINCT(name)").map(&:name)

    (states + cities + regions).each do |query|
      url = "http://#{ActionMailer::Base.default_url_options[:host]}/find/where?floorplans=any&query=#{CGI::escape query}"
      puts url
      puts CurbFu.get(url).status

      (2..3).each do |page|
        puts "#{url}&page=#{page}"
        puts CurbFu.get("#{url}&page=#{page}").status
      end
    end
  end
end
