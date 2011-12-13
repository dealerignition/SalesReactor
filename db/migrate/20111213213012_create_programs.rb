class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :type
      t.text :contact
      t.text :claim_address

      t.timestamps
    end
  end
end
