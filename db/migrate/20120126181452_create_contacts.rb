class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :type
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
