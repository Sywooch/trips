class AddDurationToTrip < ActiveRecord::Migration
  def up
    add_column :trips, :cached_duration, :integer

    Trip.find_each do |trip|
      trip.cache_duration
      trip.save
    end
  end

  def down
    remove_column :trips, :cached_duration
  end
end
