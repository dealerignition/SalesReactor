class RenameProgramType < ActiveRecord::Migration
  def up
    rename_column :programs, :type, :program_type
    rename_column :contacts, :type, :contact_type
    rename_column :phones, :type, :phone_type
  end

  def down
    rename_column :programs, :program_type,:type 
    rename_column :contacts, :contact_type, :type
    rename_column :phones, :phone_type, :type
  end
end
