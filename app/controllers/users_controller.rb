# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show follows followers]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to events_path, success: 'ユーザー登録が完了しました'
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new
    end
  end

  def show
    @following_user = @user.following_user
    @follower_user = @user.follower_user
  end

  def follows
    @users = @user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    @users = @user.follower_user.page(params[:page]).per(3).reverse_order
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
