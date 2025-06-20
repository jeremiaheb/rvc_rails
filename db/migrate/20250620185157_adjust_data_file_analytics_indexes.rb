class AdjustDataFileAnalyticsIndexes < ActiveRecord::Migration[8.0]
  def change
    change_table :data_file_analytics do |t|
      t.remove_index [:date, :ip_address, :data_type, :year, :region, :format], unique: true
      t.index [:date, :data_type, :year, :region, :format, :ip_address], unique: true
    end
  end
end
