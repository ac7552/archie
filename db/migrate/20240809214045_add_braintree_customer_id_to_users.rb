class AddBraintreeCustomerIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :braintree_customer_id, :string
    add_column :users, :braintree_payment_method_nonce, :string 
    add_column :milestones, :braintree_transaction_id, :string
    add_column :milestones, :escrow_status, :string, default: 'pending'
   end
end
