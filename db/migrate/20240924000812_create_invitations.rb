class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
      create_table :invitations do |t|
        t.integer :sender_id, index: true # Your existing user who sends the invitation
        t.integer :user_id, index: true # Your existing user who sends the invitation

        t.string :recipient_email # Email where the invite is sent
        t.string :status, default: 'pending' # Status of the invitation
        t.integer :project_id, index: true # Optional: link to a specific project
        t.datetime :sent_at # Timestamp when the invite was sent
  
        t.timestamps
      end
  
      add_foreign_key :invitations, :users, column: :sender_id
      add_foreign_key :invitations, :users, column: :user_id

      add_index :invitations, :recipient_email, unique: true
  end
end
