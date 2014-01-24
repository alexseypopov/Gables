class AddTypeToAssociates < ActiveRecord::Migration
  def self.up
    add_column :associates, :type, :string, :default => 'CommunityAssociate'
  end

  def self.down
    remove_column :associates, :type
  end
end
