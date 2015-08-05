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
      flash[:notice] = I18n.t('user_profiles.update.flash_edited')
      redirect_to user_profile_path(@user_profile)
    else
      render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:last_name, :first_name, :answer_name)
  end
end
