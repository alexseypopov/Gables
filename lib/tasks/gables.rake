namespace :gables do
  desc 'Import data from Vaultware'
  task :sync => :environment do
    begin
      Vaultware.import
      Cache.expire
    rescue => e
      #HoptoadNotifier.notify e
      puts e
    end
  end

  desc 'Import data from Property Solutions'
  task :sync_ps => :environment do
    begin
      PropertySolutions.sync
      Cache.expire
    rescue => e
      #AirbrakeNotifier.notify e
      puts e
    end
  end

  desc 'Import data from Vaultware and then from Property Solutions'
  task :chained_sync => :environment do
    begin
      Vaultware.import
      PropertySolutions.sync
      Cache.expire
    rescue => e
      #AirbrakeNotifier.notify e
      puts e
    end
  end

  desc 'Create an EBS snapshot of the server and rotate out older ones'
  task :snapshot => :environment do
    begin
      Snapshot.create
      Snapshot.rotate
    rescue => e
      HoptoadNotifier.notify e
      puts e
    end
  end

  task :clear_cache => :environment do
    begin
      Cache.expire
    rescue => e
      HoptoadNotifier.notify e
      puts e
    end
  end
  
  desc 'Prime the cache'
  task :prime_cache => :environment do
    begin
      Cache.prime
    rescue Exception => e
      HoptoadNotifier.notify e
      puts e
    end
  end

  desc 'Restarts Apache if the site is unresponsive'
  task :revive => :environment do
    testurl = 'http://gables.com/find/where?utf8=%E2%9C%93&floorplans=any&group=&query=houston&beds=&baths=&rent_min=&rent_max=&pet_friendly='

    begin
      Restarter.test(testurl)
    rescue => Curl::Err::TimeoutError
      Restarter.report(testurl)
    end
  end
end
