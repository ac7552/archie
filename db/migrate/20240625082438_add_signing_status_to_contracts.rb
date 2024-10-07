class AddSigningStatusToContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :client_signed, :boolean
    add_column :contracts, :contractor_signed, :boolean
  end
end
