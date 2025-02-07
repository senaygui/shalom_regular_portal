class AddNullSectionToNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :add_courses, :section_id, true
  end
end
