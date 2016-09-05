class CreateMyOtherModels < ActiveRecord::Migration[5.0]
  def change
    create_table :my_other_models do |t|
      t.references :my_model

      t.timestamps
    end
  end
end
