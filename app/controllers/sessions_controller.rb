class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      #authenticate once in next line and remain signin for future requests
      session[:user_id] = user.id

      flash[:notice] = "Logged in successfully"
      redirect_to user
    else
      #render not redirect to use flash[:notice]. Now we use flash.now[:alert]
      flash.now[:alert] = "There was something wrong with your login details"
      render 'new'
    end

  end

  def destroy
    #to logout make session's user id nil
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to root_path
  end

end