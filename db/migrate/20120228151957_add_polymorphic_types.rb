class AddPolymorphicTypes < ActiveRecord::Migration
  def up
    add_column :phones, :has_phones_type, :string
    add_column :contacts, :has_contacts_type, :string
  end

  def down
    remove_column :phones, :has_phones_type
    remove_column :contacts, :has_contacts_type
  end
end
