class MicropostsController < ApplicationController
  before_filter :signed_in_user
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost && @micropost.save
      redirect_to root_path, notice: "micropost created successfully"
    else
      render 'static_pages/home'
      # redirect_to root_path, notice: "micropost create failed"
    end
  end

  def destroy
    # current_user.microposts.find_by_id(params[:micropost]).destroy
    # redirect_to root_path, notice: "micropost removed"
  end
  
end
