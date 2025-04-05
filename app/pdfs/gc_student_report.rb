class GcStudentReport < Prawn::Document
  def initialize(students)
    super(:page_size => [1300, 841.89])
    @students = students
    student = @students.last
    text "Student Data", align: :center, size: 30, font_style: :bold
    stroke_horizontal_rule
    move_down 12
    table [
            ["Name of the HEI : Shalom College", " ", "Location: Addis Ababa"],
            ["Program Name : #{student.program.program_name.capitalize}", "Program Level : Postgraduate "],
            ["Modality : #{student.admission_type.capitalize}"],
            ["Admission Date: #{student.admission_date.strftime("%B,%d %Y")}"],
            ["Graduation Year:  #{student.graduation_year}"],
          ], width: 800, :cell_style => { :border_width => 0, padding: 2, font_style: :bold, size: 15 }
    move_down 20
    table each_data_in_table(@students), :cell_style => { align: :left } do
      row(0).font_style = :bold
      row(0).size = 13
      row(0).align = :center

      row(0).height = 50
    end

    move_down 10
  end

  def each_data_in_table(students)
    [
      ["ID No", "First Name", "Middle Name", "Last Name", "Sex", "Citizenship", "Birth DateD/M/Y", "Area of Training", "Area of Equevalence", "Level of Qualification", "Level of Equivalence", "Total credit hr taken", "Graduation GPA"],
    ] + students.map.with_index do |student, index|
      [student.student_id, student.first_name.capitalize, student.middle_name.capitalize, student.last_name.capitalize, student.gender, student.nationality, student.date_of_birth.strftime("%d-%B-%Y"), student.department.department_name.capitalize, "", student.admission_type.capitalize, "", student.grade_reports.sum(&:total_credit_hour), student.grade_reports.sum(&:cgpa)]
    end
  end
end
