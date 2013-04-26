class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost && @micropost.save
      redirect_to root_path, notice: "micropost created successfully"
    else
      @feed_items = []
      render 'static_pages/home'

      # redirect_to root_path, notice: "micropost create failed"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url, notice: "micropost destroy successfully"
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end
  
end
