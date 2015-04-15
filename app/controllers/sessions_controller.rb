class SessionsController < ApplicationController

  before_action :require_current_user!, except: [:create, :new]
  before_action :require_current_user_nil!, only: [:create, :new]

  def new
    render :new
  end

  def create
    # verify user_name/password, sign user in

    @user = User.find_by_credentials(params['user']['user_name'], params['user']['password'])

    if @user.nil?
      render :new
    else
      login_user!(@user)

      redirect_to cats_url
    end

  end

  def destroy
    @user = User.find_by(session_token: self.session[:session_token])

    session[:session_token] = nil
    @user.reset_session_token!

    redirect_to new_session_url
  end
end
