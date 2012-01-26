class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :country
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
