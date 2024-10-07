class AddStripePaymentIntentIdToMilestones < ActiveRecord::Migration[7.1]
  def change
    add_column :milestones, :stripe_payment_intent_id, :string
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_card_id, :string
  end
end
