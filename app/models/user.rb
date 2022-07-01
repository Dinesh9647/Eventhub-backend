class User < ApplicationRecord
    has_many :registrations, dependent: :destroy
    has_many :events, through: :registrations
    has_secure_password

    validates :username, presence: true
    validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 7 }, allow_nil: true
    validates :role, inclusion: { in: ["super", "admin", "user"] }
end
