class Photo < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :photo, presence: true
end
