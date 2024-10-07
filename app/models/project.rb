class Project < ApplicationRecord


  has_many :milestones
  has_one :contract
  has_many :questionnaires

  validates :title, :description, presence: true
end