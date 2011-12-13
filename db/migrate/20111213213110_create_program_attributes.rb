class CreateProgramAttributes < ActiveRecord::Migration
  def change
    create_table :program_attributes do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
