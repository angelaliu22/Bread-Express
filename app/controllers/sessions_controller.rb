class SessionsController < ApplicationController
    
    include BreadExpressHelpers::Cart
    
  def new
  end
  
  def create
      user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
        create_cart
    else
        flash.now.alert = "Username or password is invalid"
      render "new"
    end
  end
  
  def destroy
      destroy_cart
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end