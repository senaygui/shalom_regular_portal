require 'rails_helper'

RSpec.describe "exemptions/show", type: :view do
  before(:each) do
    assign(:exemption, Exemption.create!(
      course_title: "Course Title",
      letter_grade: "Letter Grade",
      course_code: "Course Code",
      credit_hour: 2,
      department_approval: "Department Approval",
      dean_approval: "Dean Approval",
      registeral_approval: "Registeral Approval",
      exemption_needed: false,
      extrnal_transfer: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Course Title/)
    expect(rendered).to match(/Letter Grade/)
    expect(rendered).to match(/Course Code/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Department Approval/)
    expect(rendered).to match(/Dean Approval/)
    expect(rendered).to match(/Registeral Approval/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
