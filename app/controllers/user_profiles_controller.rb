class UserProfilesController < ApplicationController
  def show
    @user_profile = UserProfile.find(params[:id])
  end

  def edit
    @user_profile = UserProfile.find(params[:id])
  end

  def update
    @user_profile = UserProfile.find(params[:id])

    result = @user_profile.update_attributes(user_profile_params)
    if result
      redirect_to user_profile_path(@user_profile)
    else
      render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:first_name, :last_name)
  end
end
