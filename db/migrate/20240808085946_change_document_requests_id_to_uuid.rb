class ChangeDocumentRequestsIdToUuid < ActiveRecord::Migration[7.0]
  def up
    # Add a temporary UUID column
    add_column :document_requests, :uuid, :uuid, default: -> { "uuid_generate_v4()" }, null: false

    # Update the new UUID column with generated UUIDs
    execute <<-SQL
      UPDATE document_requests
      SET uuid = uuid_generate_v4()
    SQL

    # Ensure no primary key constraint exists before renaming columns
    execute <<-SQL
      ALTER TABLE document_requests
      DROP CONSTRAINT IF EXISTS document_requests_pkey
    SQL

    # Rename the ID columns
    rename_column :document_requests, :id, :integer_id
    rename_column :document_requests, :uuid, :id

    # Set the new UUID column as primary key
    execute <<-SQL
      ALTER TABLE document_requests
      ADD PRIMARY KEY (id)
    SQL

    # Remove the old integer ID column
    remove_column :document_requests, :integer_id
  end

  def down
    # Add a temporary integer column
    add_column :document_requests, :integer_id, :integer

    # Copy data from UUID to integer ID (assuming UUIDs are converted to integers somehow)
    execute <<-SQL
      UPDATE document_requests
      SET integer_id = id::integer
    SQL

    # Ensure no primary key constraint exists before renaming columns
    execute <<-SQL
      ALTER TABLE document_requests
      DROP CONSTRAINT IF EXISTS document_requests_pkey
    SQL

    # Rename the ID columns
    rename_column :document_requests, :id, :uuid
    rename_column :document_requests, :integer_id, :id

    # Set the new integer column as primary key
    execute <<-SQL
      ALTER TABLE document_requests
      ADD PRIMARY KEY (id)
    SQL

    # Remove the old UUID column
    remove_column :document_requests, :uuid
  end
end
