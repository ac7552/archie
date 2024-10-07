class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions do |t|
      t.references :contract, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
