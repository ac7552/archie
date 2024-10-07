class Invitation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :project, optional: true

  validates :recipient_email, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[pending accepted declined] }
end