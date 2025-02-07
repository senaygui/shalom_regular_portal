require 'rails_helper'

RSpec.describe "exemptions/edit", type: :view do
  let(:exemption) {
    Exemption.create!(
      course_title: "MyString",
      letter_grade: "MyString",
      course_code: "MyString",
      credit_hour: 1,
      department_approval: "MyString",
      dean_approval: "MyString",
      registeral_approval: "MyString",
      exemption_needed: false,
      extrnal_transfer: nil
    )
  }

  before(:each) do
    assign(:exemption, exemption)
  end

  it "renders the edit exemption form" do
    render

    assert_select "form[action=?][method=?]", exemption_path(exemption), "post" do

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
