class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:cluster_id] = user.cluster
      redirect_to root_path, notice: "Welcome"
    else
         redirect_to new_user_path,  notice: "Invalid login credentials. Please contact support"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out."
  end
end
