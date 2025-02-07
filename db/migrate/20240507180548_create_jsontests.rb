class CreateJsontests < ActiveRecord::Migration[7.0]
  def change
    create_table :jsontests do |t|
      t.jsonb :result

      t.timestamps
    end
  end
end
