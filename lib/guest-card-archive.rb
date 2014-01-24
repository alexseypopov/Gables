table = Tablet::Guest
guests = table.where("TO_DAYS(NOW())-TO_DAYS(updated_at) >= 30",:guest_card_id => nil)

data = guests.collect do |tg|
  table.column_names.map { |column| tg.send(column) }
end

filename = "guest-card-archive-#{Time.now.to_date}.csv"
CSV.open("tmp/#{filename}", "w") do |output_file|
  output_file << table.column_names
  data.each{ |row| output_file << row }
end

storage = Fog::Storage.new({
  :provider               => 'AWS',
  :aws_access_key_id      => 'AKIAJJW7WHQPQPY3IZCQ',
  :aws_secret_access_key  => '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'
})

directory = storage.directories.get("tablet-guest-card-archive")

file = directory.files.create(
  :key  => filename,
  :body => File.open("tmp/#{filename}")
)

guests.group_by{|tg| tg.tablet_property_id}.each do |property_id, property_guests|
  property = Tablet::Property.find_by_id(property_id)
  if property
    filename = "guest-card-archive-#{Time.now.to_date}-#{property.name.parameterize}.csv"
    CSV.open("tmp/#{filename}", "w") do |output_file|
      output_file << table.column_names
      property_guests.collect do |tg|
        table.column_names.map { |column| tg.send(column) }
      end.each{ |row| output_file << row }
    end
    Tablet::GuestCardMailer.archived_guest_cards(:to => property, :filename => filename).deliver
  end
end

puts "#{Time.now} Archiving Tablet::Guests: #{guests.map(&:id)}"
guests.each {|g| g.inactive = true; g.save}

