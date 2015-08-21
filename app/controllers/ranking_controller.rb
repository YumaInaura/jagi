class RankingController < ApplicationController
  def index
    @ranking_user_profiles = UserProfile.ranking_user_profiles
  end
end
