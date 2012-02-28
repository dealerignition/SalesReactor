class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone_type
      t.string :number

      t.timestamps
      t.references :has_phones, :polymorphic => true
    end
  end
end
