class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :company_id
      t.string :type
      t.text :products
      t.text :trademarks
      t.text :notes

      t.timestamps
    end
  end
end
