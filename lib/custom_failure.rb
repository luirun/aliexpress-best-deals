class CustomFailure < Devise::FailureApp
  def redirect_url
    your_path
  end

  def respond
    if http_auth?
      http_auth
    else
      flash[:alert] = "The email and password you entered did not match our records. Please double-check and try again."
      redirect_to "/login"
    end
  end
end