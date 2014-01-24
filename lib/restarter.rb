class Restarter
  
  # Raises a Curl::Err::TimeoutError if testurl doesn't download within the timeout
  def self.test(testurl)
    CurbFu.get(testurl){|curb| curb.timeout = 60}
  end

  def self.report(testurl)
    warning = "Restarting Apache due to timeout GETting #{testurl}"

    Rails.logger.warn "[#{Time.now}] #{warning}"
    Rails.logger.warn "ps aux"
    Rails.logger.warn `ps aux`

    Rails.logger.warn "sudo passenger-status --verbose"
    Rails.logger.warn `sudo passenger-status --verbose`

    HoptoadNotifier.notify Exception.new(warning)
    `sudo apache2ctl restart`
  end
end
