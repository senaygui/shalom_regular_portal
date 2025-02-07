class AddStatusToSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :section_status, :integer, default: 0
    add_column :sections, :batch, :string
  end
end
