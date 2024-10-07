class AddRevisionsToContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :revisions, :text
  end
end
