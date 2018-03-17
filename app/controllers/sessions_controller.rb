class SessionsController < ApplicationController
  def new; end

  def create
    user = User.where(email: params[:user][:email]).first
      if user && user.authenticate(secure_params[:password])
        session[:id] = user.id
        log_in user
        flash[:notice] = "Welcome back #{user.name} #{user.surname}!"
      else
        flash[:alert] = 'Invalid email/password combination'
      end
    redirect_to session[:return_to]
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def secure_params
    params.require(:session).permit(:email, :password, :id)
  end
end
