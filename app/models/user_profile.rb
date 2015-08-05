class UserProfile < ActiveRecord::Base
  belongs_to :user
  validates :first_name, length: { maximum: 30 }
  validates :first_name, presence: true
  validates :last_name, length: { maximum: 30 }
  validates :last_name, presence: true
  validates :answer_name, length: { maximum: 30 }
  validates :answer_name, presence: true
end
