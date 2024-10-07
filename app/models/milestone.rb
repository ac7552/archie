class Milestone < ApplicationRecord
  belongs_to :project

  validates :title, :description, :deadline, :escrow_amount, presence: true

  enum status: { pending: 0, completed: 1 }

  attribute :status, :integer, default: 0
end