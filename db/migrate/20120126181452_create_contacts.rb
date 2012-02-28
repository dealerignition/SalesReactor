class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :contact_type
      t.string :title
      t.string :email

      t.timestamps
      t.references :has_contacts, :polymorphic => true
    end
  end
end
