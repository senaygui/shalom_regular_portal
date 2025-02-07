class AddFieldsToSchoolOrUniversityInformations < ActiveRecord::Migration[7.0]
  def change
    add_column :school_or_university_informations, :coc_id, :string
    add_column :school_or_university_informations, :tvet, :string
    add_column :school_or_university_informations, :letter_of_equivalence, :string
    add_column :school_or_university_informations, :entrance_exam_id, :string
  end
end
