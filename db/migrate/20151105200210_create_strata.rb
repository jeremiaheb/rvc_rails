class CreateStrata < ActiveRecord::Migration
  def change
    create_table :strata do |t|

      t.timestamps null: false
    end
  end
end
