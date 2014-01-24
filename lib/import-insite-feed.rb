#!/usr/bin/env ruby

storage = Fog::Storage.new({
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJJW7WHQPQPY3IZCQ',
    :aws_secret_access_key  => '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'
})

files = {
  :InSiteUsers => {
    :table => Tablet::InsiteUser,
    :headers => %w(id user_id name email)
  },
  :LeadSources => {
    :table => Tablet::LeadSource,
    :headers => %w(tablet_property_id id name)
  },
  :Properties => {
    :table => Tablet::Property,
    :headers => %w(vaultware_id name id community_manager community_manager_email
                    regional_manager regional_manager_email state vaultware_id phone)
  },
  :ReasonsLooking => {
    :table => Tablet::LeasingReason,
    :headers => %w(id name)
  },
  :ReasonsNotLeased => {
    :table => Tablet::NotLeasingReason,
    :headers => %w(id name)
  }
}

files.each do |file, options|
  url = storage.get_object_url("gables-tablet-app-feeds","#{file}.csv",Time.now + 10.minutes)
  `wget -O tmp/#{file}.csv "#{url}"`

  options[:table].destroy_all

  csv = CSV.open("tmp/#{file}.csv", :headers => options[:headers])
  csv.shift
  csv.each do |row|
    row.fields.compact.map(&:strip!)
    model = options[:table].new(row.to_hash)
    model.id = row["id"]
    model.save!
    puts model.inspect
  end
end

