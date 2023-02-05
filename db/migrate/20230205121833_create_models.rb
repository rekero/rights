class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name, nullable: false

      t.timestamps
    end

    create_table :albums do |t|
      t.integer :artist_id
      t.string :upc
      t.string :release_title
      t.integer :release_year

      t.timestamps
    end

    create_table :tracks do |t|
      t.integer :album_id
      t.integer :artist_id
      t.string :isrc
      t.string :name, nullable: false

      t.timestamps
    end

    create_table :sales do |t|
      t.references :origin, polymorphic: true
      t.integer :transaction_type_id
      t.decimal :revenue_for_label, precision: 10, scale: 8
      t.decimal :revenue_for_artist, precision: 10, scale: 8

      t.timestamps
    end

    create_table :transaction_types do |t|
      t.string :name
      t.decimal :proportion, precision: 10, scale: 8

      t.timestamps
    end
  end
end
