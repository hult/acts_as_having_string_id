class RefactorTestModelsAgain < ActiveRecord::Migration[5.0]
  def change
    drop_table :as
    drop_table :bs
    drop_table :cs
    drop_table :ds
    drop_table :es
    drop_table :fs

    create_table :publishers do |t|
      t.timestamps
    end

    create_table :authors do |t|
      t.timestamps
    end

    create_table :authors_publishers do |t|
      t.references :author
      t.references :publisher
      t.timestamps
    end

    create_table :books do |t|
      t.references :author
      t.timestamps
    end

    create_table :editions do |t|
      t.references :book
      t.timestamps
    end

    create_table :covers do |t|
      t.references :book
      t.timestamps
    end

    create_table :images do |t|
      t.references :cover
      t.timestamps
    end
  end
end
