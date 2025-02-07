require 'rails_helper'

RSpec.describe "external_transfers/new", type: :view do
  before(:each) do
    assign(:external_transfer, ExternalTransfer.new(
      first_name: "MyString",
      last_name: "MyString",
      department: nil,
      previous_institution: "MyString",
      previous_student_id: "MyString",
      status: 1
    ))
  end

  it "renders new external_transfer form" do
    render

    assert_select "form[action=?][method=?]", external_transfers_path, "post" do

      assert_select "input[name=?]", "external_transfer[first_name]"

      assert_select "input[name=?]", "external_transfer[last_name]"

      assert_select "input[name=?]", "external_transfer[department_id]"

      assert_select "input[name=?]", "external_transfer[previous_institution]"

      assert_select "input[name=?]", "external_transfer[previous_student_id]"

      assert_select "input[name=?]", "external_transfer[status]"
    end
  end
end
