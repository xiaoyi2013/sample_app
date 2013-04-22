class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      # sign in success and show user'name and user's touxiang and micro_posts
      # redirect_to user_path(user)
      sign_in user
      redirect_to user
    else
      flash.now[:error] = "Invalid email/password combination" # not quite right
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
