class Program < ActiveRecord::Migration
  def up
    add_column :programs, :category, :string
  end

  def down
    remove_column :programs, :category
  end
end
