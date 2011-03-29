class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :service
      t.string :user_id
      t.string :name
      t.string :email
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
