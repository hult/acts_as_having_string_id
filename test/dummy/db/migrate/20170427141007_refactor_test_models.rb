class RefactorTestModels < ActiveRecord::Migration[5.0]
  def change
    drop_table :details
    drop_table :my_other_models
    drop_table :my_models

    create_table :as do |t|
      t.timestamps
    end

    create_table :bs do |t|
      t.references :a
      t.timestamps
    end

    create_table :cs do |t|
      t.references :b
      t.timestamps
    end

    create_table :ds do |t|
      t.timestamps
    end

    create_table :as_ds do |t|
      t.references :a
      t.references :d
      t.timestamps
    end

    create_table :es do |t|
      t.references :a
      t.timestamps
    end
  end
end
