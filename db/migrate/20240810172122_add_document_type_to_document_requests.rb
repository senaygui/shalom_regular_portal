class AddDocumentTypeToDocumentRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :document_requests, :document_type, :string
  end
end
