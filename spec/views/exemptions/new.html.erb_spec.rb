require 'rails_helper'

RSpec.describe "exemptions/new", type: :view do
  before(:each) do
    assign(:exemption, Exemption.new(
      course_title: "MyString",
      letter_grade: "MyString",
      course_code: "MyString",
      credit_hour: 1,
      department_approval: "MyString",
      dean_approval: "MyString",
      registeral_approval: "MyString",
      exemption_needed: false,
      extrnal_transfer: nil
    ))
  end

  it "renders new exemption form" do
    render

    assert_select "form[action=?][method=?]", exemptions_path, "post" do

      assert_select "input[name=?]", "exemption[course_title]"

      assert_select "input[name=?]", "exemption[letter_grade]"

      assert_select "input[name=?]", "exemption[course_code]"

      assert_select "input[name=?]", "exemption[credit_hour]"

      assert_select "input[name=?]", "exemption[department_approval]"

      assert_select "input[name=?]", "exemption[dean_approval]"

      assert_select "input[name=?]", "exemption[registeral_approval]"

      assert_select "input[name=?]", "exemption[exemption_needed]"

      assert_select "input[name=?]", "exemption[extrnal_transfer_id]"
    end
  end
end
