class ProfileImage < ActiveRecord::Base
  belongs_to :user_profile

  validates :user_profile_id, presence: true, numericality: true
  validates :image, presence: true
  validates :situation, presence: true

  mount_uploader :image, ImageUploader

  def self.situations
    [:normal, :correct, :incorrect]
  end

  def self.save_image(params)
    return unless params[:image]

    profile_image = ProfileImage.find_or_create_by(user_profile_id: params[:user_profile_id] , situation: params[:situation])
    profile_image.update(params)
  end
end

