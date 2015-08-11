class UserProfilesController < ApplicationController
  def show
    @user_profile = UserProfile.find(params[:id])
  end

  def new
    i_am_not_logined_then_raise
    i_have_user_profile_then_redirect

    @user_profile = UserProfile.new
  end

  def create
    i_am_not_logined_then_raise
    i_have_user_profile_then_redirect

    @user_profile = UserProfile.find_by(user_id: current_user.id)

    create_data = user_profile_params
    create_data[:user_id] = current_user.id

    if UserProfile.create(create_data)
      @created_user_profile = my_user_profile
      flash[:notice] = I18n.t('user_profiles.update.flash_edited')
      redirect_to edit_user_profile_path(@created_user_profile)
    else
      render :new
    end
  end

  def edit
    i_am_not_logined_then_raise
    i_have_no_user_profile_then_raise

    @user_profile = UserProfile.find(params[:id])
  end

  def update
    i_am_not_logined_then_raise
    i_have_no_user_profile_then_raise

    @user_profile = UserProfile.find(params[:id])
    @my_user_profile = my_user_profile

      if @user_profile.user_id != current_user.id
        raise StandardError.new('あなたのアカウントではありません。')
      end

    result = @user_profile.update_attributes(user_profile_params)
    if result
      flash[:notice] = I18n.t('user_profiles.update.flash_edited')
      redirect_to edit_user_profile_path(@user_profile)
    else
     render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:last_name, :first_name, :answer_name)
  end

  def i_am_not_logined_then_raise
    unless current_user
      raise StandardError.new('ログインしてください。')
    end
  end

  def my_user_profile
    if current_user
      return UserProfile.find_by(user_id: current_user.id)
    else
      return nil
    end
  end

  def i_have_user_profile_then_redirect
    if my_user_profile
      redirect_to :action => 'edit', :id => my_user_profile.id
    end
  end

  def i_have_no_user_profile_then_raise
    unless my_user_profile
      raise StandardError.new('あなたはまだプロフィールを作成していません。')
    end
  end

end
