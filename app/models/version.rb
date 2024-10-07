class Version < ApplicationRecord
    belongs_to :contract
  
    validates :contract_id, :version_number, :content, presence: true
  end