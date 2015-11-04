class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.integer :year
      t.string :region
      t.string :sample_path
      t.string :stratum_path

      t.timestamps null: false
    end
  end
end
