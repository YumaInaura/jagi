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

  def correct?(answer)
    result = false
    result = true if answer == self.name
    result = true if self.answer_name.present? && answer == self.answer_name
    result
  end

  def total_correct
    Answer.where(correct: true, user_profile_id: self.id).count
  end

  def total_incorrect
    Answer.where(correct: false, user_profile_id: self.id).count
  end

  def find_image(situation)
    profile_image = ProfileImage.find_by(user_profile_id: self.id, situation: situation)
    profile_image.present? ? profile_image.image : nil
  end

  def find_image_url(situation)
    image = find_image(situation)
    image.present? ? image.url : nil
  end
end
