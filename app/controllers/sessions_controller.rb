class SessionsController < ApplicationController

  def new
  
  end
  
	def create
		user = User.where(email: params[:session][:email]).first
			if user && user.authenticate(secure_params[:password])
				session[:id] = user.id
				log_in user
				flash[:notice] = "Welcome back #{user.name} #{user.surname}!"
				redirect_to root_path
			else
				flash[:alert] = 'Invalid email/password combination'
				redirect_to root_path
			end
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
