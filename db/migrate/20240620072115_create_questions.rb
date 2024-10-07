class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :questionnaire, null: false, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
