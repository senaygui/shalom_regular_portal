class AddSectionToStudent < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :section, null: true, foreign_key: true, type: :uuid
    add_column :students, :section_status, :integer, default: 0
  end
end
