class ApplicationController < ActionController::Base
  before_action :set_current_user
  
  private
  
  def set_current_user
    return unless session[:user_id]
    @current_user = User.find_by(id: session[:user_id])
  end
  
  def authenticate_user!
    return if @current_user
    redirect_to '/login'
  end
end
