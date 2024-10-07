class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :freelancer_id
      t.integer :client_id
      t.text :content
      t.string :status
      t.string :docusign_id

      t.timestamps
    end
  end
end
