class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.authenticate(params[:username], params[:password])
	  if @user
	    session[:user_id] = @user.id
	    redirect_to nodes_path, :notice => "Logged in!"
	  else
	    flash.now.alert = "Invalid Username or Password"
	    render "new"
	  end
  end

  def destroy
	session[:user_id] = nil
	redirect_to log_in_path, :notice => "Logged out!"
  end
end
