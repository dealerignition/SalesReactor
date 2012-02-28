class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :program_type
      t.string :category
      t.text :products
      t.text :trademarks
      t.text :notes

      t.timestamps
      t.references :company
    end
  end
end
