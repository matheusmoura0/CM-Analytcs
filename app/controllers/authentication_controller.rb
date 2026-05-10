class AuthenticationController < ApplicationController
  skip_before_action :set_current_user, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def new
    render layout: false
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.update_column(:last_sign_in_at, Time.current)
      render json: { success: true, redirect: '/dashboard' }
    else
      render json: { success: false, error: 'Credenciais inválidas' }, status: :unauthorized
    end
  end
  
  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to '/login'
  end
end
