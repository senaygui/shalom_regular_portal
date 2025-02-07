require 'rails_helper'

RSpec.describe "exemptions/index", type: :view do
  before(:each) do
    assign(:exemptions, [
      Exemption.create!(
        course_title: "Course Title",
        letter_grade: "Letter Grade",
        course_code: "Course Code",
        credit_hour: 2,
        department_approval: "Department Approval",
        dean_approval: "Dean Approval",
        registeral_approval: "Registeral Approval",
        exemption_needed: false,
        extrnal_transfer: nil
      ),
      Exemption.create!(
        course_title: "Course Title",
        letter_grade: "Letter Grade",
        course_code: "Course Code",
        credit_hour: 2,
        department_approval: "Department Approval",
        dean_approval: "Dean Approval",
        registeral_approval: "Registeral Approval",
        exemption_needed: false,
        extrnal_transfer: nil
      )
    ])
  end

  it "renders a list of exemptions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Course Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Letter Grade".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Course Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Department Approval".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Dean Approval".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Registeral Approval".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
