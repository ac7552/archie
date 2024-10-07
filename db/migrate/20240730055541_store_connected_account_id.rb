class StoreConnectedAccountId < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :connected_account_id, :string
  end
end
