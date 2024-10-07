class User < ApplicationRecord
            # Include default devise modules.
            devise :database_authenticatable, :registerable,
                    :recoverable, :rememberable, :trackable, :validatable,
                    :confirmable, :omniauthable
            include DeviseTokenAuth::Concerns::User
  has_many :contracts, foreign_key: :client_id, dependent: :destroy
  has_many :freelancer_contracts, class_name: 'Contract', foreign_key: :freelancer_id
  has_many :client_projects, class_name: 'Project', foreign_key: 'client_id'
  has_many :freelancer_projects, class_name: 'Project', foreign_key: 'freelancer_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
  :jwt_authenticatable, jwt_revocation_strategy: self
  ROLES = %w[client freelancer].freeze

  # validates :role, presence: true, inclusion: { in: ROLES }
  attr_accessor :client_payment_method_id, :freelancer_payment_method_id

  def client?
    role == 'client'
  end

  def freelancer?
    role == 'freelancer'
  end

  def password_required?
    false
  end
end
