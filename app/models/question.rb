class Question < ApplicationRecord
  belongs_to :questionnaire

  QUESTION_TYPES = [
    'Introduction',
    'Scope of Work',
    'Payment Terms',
    'Responsibilities of Parties',
    'Confidentiality',
    'Termination',
    'Signatures'
  ].freeze


  validates :question, presence: true
  validates :question_type, inclusion: { in: QUESTION_TYPES }
end
