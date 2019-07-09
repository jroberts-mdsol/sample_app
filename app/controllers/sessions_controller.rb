class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log user in and redirect to user's show page
      flash[:success] = "Welcome back, #{user.name.partition(' ').first}"
      log_in user
      redirect_to user
    else
      # Create error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end