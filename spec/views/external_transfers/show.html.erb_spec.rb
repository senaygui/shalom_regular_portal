require 'rails_helper'

RSpec.describe "external_transfers/show", type: :view do
  before(:each) do
    assign(:external_transfer, ExternalTransfer.create!(
      first_name: "First Name",
      last_name: "Last Name",
      department: nil,
      previous_institution: "Previous Institution",
      previous_student_id: "Previous Student",
      status: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Previous Institution/)
    expect(rendered).to match(/Previous Student/)
    expect(rendered).to match(/2/)
  end
end
