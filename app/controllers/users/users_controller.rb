class Users::UsersController < ApplicationController
  def show
    @user = current_user
    @name = @user.name
    @image = @user.image
    @profile = @user.profile
  end

  def edit
    @user = current_user
    @image = @user.image
  end
  
  def update
    if current_user.update(user_params)
      redirect_to current_user_path(current_user),success: "ユーザーを更新しました"
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit
    end
  end
  
  private
  def set_user
      @user = User.find(current_user.id)
  end
  
  def user_params
    params.require(:user).permit(:id, :name, :username, :email, :image, :profile)
  end
  
end
