class CreateUneditableCourseModules < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_course_modules, id: :uuid do |t|
      t.string :module_title, null: false
      t.uuid :department_id
      t.string :module_code, null: false
      t.text :overview
      t.text :description
      t.string :created_by
      t.string :last_updated_by
      t.timestamps
    end
  end
end
