require 'rails_helper'

RSpec.describe "external_transfers/edit", type: :view do
  let(:external_transfer) {
    ExternalTransfer.create!(
      first_name: "MyString",
      last_name: "MyString",
      department: nil,
      previous_institution: "MyString",
      previous_student_id: "MyString",
      status: 1
    )
  }

  before(:each) do
    assign(:external_transfer, external_transfer)
  end

  it "renders the edit external_transfer form" do
    render

    assert_select "form[action=?][method=?]", external_transfer_path(external_transfer), "post" do

      assert_select "input[name=?]", "external_transfer[first_name]"

      assert_select "input[name=?]", "external_transfer[last_name]"

      assert_select "input[name=?]", "external_transfer[department_id]"

      assert_select "input[name=?]", "external_transfer[previous_institution]"

      assert_select "input[name=?]", "external_transfer[previous_student_id]"

      assert_select "input[name=?]", "external_transfer[status]"
    end
  end
end
