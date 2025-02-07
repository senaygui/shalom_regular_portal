class AddVerifiedToReadmissions < ActiveRecord::Migration[7.0]
  def change
    change_column_default :readmissions, :verified, false
  end
end
