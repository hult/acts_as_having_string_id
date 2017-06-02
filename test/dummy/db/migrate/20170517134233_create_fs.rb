class CreateFs < ActiveRecord::Migration[5.0]
  def change
    create_table :fs do |t|
      t.timestamps
    end

    add_column :as, :f_id, :integer
  end
end
