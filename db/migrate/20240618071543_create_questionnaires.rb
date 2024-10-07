class CreateQuestionnaires < ActiveRecord::Migration[7.1]
  def change
    create_table :questionnaires do |t|
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
