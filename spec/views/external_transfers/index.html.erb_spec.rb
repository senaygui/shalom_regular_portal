require 'rails_helper'

RSpec.describe "external_transfers/index", type: :view do
  before(:each) do
    assign(:external_transfers, [
      ExternalTransfer.create!(
        first_name: "First Name",
        last_name: "Last Name",
        department: nil,
        previous_institution: "Previous Institution",
        previous_student_id: "Previous Student",
        status: 2
      ),
      ExternalTransfer.create!(
        first_name: "First Name",
        last_name: "Last Name",
        department: nil,
        previous_institution: "Previous Institution",
        previous_student_id: "Previous Student",
        status: 2
      )
    ])
  end

  it "renders a list of external_transfers" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Previous Institution".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Previous Student".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
