class CreateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :details do |t|
      t.references :my_other_model
      t.timestamps
    end
  end
end
