class CreateDataFileAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :data_file_analytics do |t|
      t.date :date, null: false
      t.string :ip_address, null: false
      t.string :data_type, null: false
      t.integer :year, null: false
      t.string :region, null: false
      t.string :format, null: false
      t.integer :count, default: 0, null: false

      t.timestamps null: false

      t.index [:date, :ip_address, :data_type, :year, :region, :format], unique: true
    end
  end
end
