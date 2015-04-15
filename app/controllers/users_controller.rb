class UsersController < ApplicationController

  before_action :require_current_user!, except: [:create, :new]
  before_action :require_current_user_nil!, only: [:create, :new]

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to cats_url
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end


end
