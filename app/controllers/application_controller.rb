class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:session_token].nil?

    @current_user ||= User.find_by(session_token:          session[:session_token])
  end

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end

  def require_current_user_nil!
    redirect_to cats_url unless current_user.nil?
  end

  def require_ownership!
    cat = Cat.find(params[:id])

    unless cat.owner == current_user
      flash[:errors] = ["Can't edit cat you don't own."]
      redirect_to cat_url(cat)
    end
  end

  def require_ownership_to_change_status!
    cat = CatRentalRequest.find(params[:id]).cat

    unless cat.owner == current_user
      flash[:errors] = ["Can't approve or deny rental request for cat you don't own."]
      redirect_to cat_url(cat)
    end
  end
end
