class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.primary_key :id
      t.string :type
      t.string :number

      t.timestamps
    end
  end
end
