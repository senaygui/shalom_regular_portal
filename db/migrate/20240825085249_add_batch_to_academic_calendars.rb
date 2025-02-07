class AddBatchToAcademicCalendars < ActiveRecord::Migration[7.0]
  def change
    add_column :academic_calendars, :batch, :string, null: true
  end
end
