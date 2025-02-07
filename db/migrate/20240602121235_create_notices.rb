class CreateNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :body
      t.string :posted_by

      t.timestamps
    end
  end
end
