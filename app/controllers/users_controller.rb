class UsersController < ApplicationController
  before_filter :unauthorized,   only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save
      sign_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user && @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
  private
  
  def unauthorized
    # flash[:notice] = "Please sign in"
    store_location
    redirect_to signin_path, notice: "Please sign in" unless sign_in?
  end

  def correct_user
    # flash[:notice] = "Can't edit another user's profile"
    @user = User.find(params[:id])
    
    redirect_to root_path, notice: "Canit edit another user's profile" unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
  
end
