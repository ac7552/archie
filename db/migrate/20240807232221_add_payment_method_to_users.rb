class AddPaymentMethodToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :payment_method_id, :string
  end
end
