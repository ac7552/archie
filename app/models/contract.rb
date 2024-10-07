class Contract < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User', optional: true
  belongs_to :client, class_name: 'User', optional: true
  has_many :versions, dependent: :destroy

  validates :content, presence: true

  after_create :create_initial_version

  def create_version
    version_number = versions.maximum(:version_number) || 0
    versions.create(version_number: version_number + 1, content: content)
  end

  private

  def create_initial_version
    versions.create(version_number: 1, content: content)
  end
end
