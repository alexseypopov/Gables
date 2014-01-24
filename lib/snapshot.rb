require 'csv'

class Snapshot
  Volume      = 'vol-ecc01286'
  AuthOptions = "-K #{Rails.root.join('config/pk-snapshotter.pem')} -C #{Rails.root.join('config/cert-snapshotter.pem')}"

  class << self
    def create
      command = "ec2-create-snapshot #{AuthOptions} #{Volume} -d 'backup'"
      Rails.logger.warn "[#{Time.now}] Creating snapshot"
      Rails.logger.warn `#{command}`

      if $?.exitstatus != 0
        Rails.logger.warn "[#{Time.now}] Snapshotting failed"
        HoptoadNotifier.notify(Exception.new("Snapshotting failed"))
      end
    end

    def rotate
      surplus_snapshots(snapshot_list).each do |snapshot|
        delete(snapshot.snapshot_id)
        Rails.logger.warn "[#{Time.now}] Deleted snapshot: #{snapshot.snapshot_id}\t#{snapshot.time}"
      end
    end

    def snapshot_list
      list_cmd = "ec2-describe-snapshots #{AuthOptions}"
      rows = CSV.parse `#{list_cmd}`, "\t"
      
      snapshots = rows.map do |row|
        begin
          timestamp   = DateTime.parse(row[4])
        rescue ArgumentError
          next
        end

        label       = row[8]
        volume      = row[2]
        snapshot_id = row[1]

        if label == "backup" && volume == Volume
          OpenStruct.new({
            :time         => timestamp,
            :snapshot_id  => snapshot_id
          })
        end
      end

      snapshots.compact.sort{|x, y| y.time <=> x.time}
    end

    def earliest(a)
     _, *rest = *a
     rest
    end

    def surplus_snapshots(unprocessed)
      start       = DateTime.now

      backup_ranges = [[365, :day]]
      to_delete     = []

      backup_ranges.each do |backup_range|
        extent  = backup_range.first
        type    = backup_range.last
        
        (1..extent).each do |i|
          in_range_snapshots, *rest =  *(unprocessed.partition{|s| start - i.send(type) < s.time})
          unprocessed = rest.flatten
          break unless in_range_snapshots

          unless in_range_snapshots.empty?
            to_delete.concat(earliest(in_range_snapshots))
          end
        end
      end

      to_delete + unprocessed
    end

    def delete(snapshot_id)
      `ec2-delete-snapshot #{AuthOptions} #{snapshot_id}` 
    end
  end
end
