class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.datetime :expiration
      t.float :participation_percent
      t.float :manufacturer_accrual
      t.integer :id
      t.string :name
      t.text :address
      t.string :telephone
      t.string :fax
      t.string :website
      t.string :email
      t.string :tollfree

      t.timestamps
    end
  end
end
