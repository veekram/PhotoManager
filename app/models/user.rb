class User < ApplicationRecord
  has_secure_password

  validates :identity, presence: true, uniqueness: true

  has_many :photos

end
