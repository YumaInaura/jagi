class UserProfile < ActiveRecord::Base
  belongs_to :user
  has_many :profile_images
  belongs_to :project
  belongs_to :group

  delegate :name, to: :user

  validates :user_id, presence: true, numericality: true, uniqueness: true
  validates :answer_name, allow_nil: true, length: { maximum: 30 }
  validates :group_id, allow_nil: true, numericality: true
  validates :project_id, allow_nil: true, numericality: true
  validates :gender, allow_nil: true, inclusion: { in: ['', 'male', 'female'] }
  validates :joined_year, allow_nil: true, numericality: true
  validates :detail, allow_nil: true, length: { maximum: 10000 }

  def answer_user
    self.class.all.sample
  end

  def total_correct
    Answer.where(correct: true, user_profile_id: self.id).count
  end

  def total_incorrect
    Answer.where(correct: false, user_profile_id: self.id).count
  end
end
