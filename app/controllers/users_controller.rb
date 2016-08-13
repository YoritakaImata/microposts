class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  
  def index
   @users = User.all.order(created_at: :desc)
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Updated your Plofile"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def followings
    @title = 'followings'
    @user = User.find(params[:id])
    @users = @user.following_users.order(created_at: :desc)
    render 'show_follow'
  end
  
  def followers
    @title = 'followers'
    @user = User.find(params[:id])
    @users = @user.follower_users.order(created_at: :desc)
    render 'show_follow'
  end
  
  def retweet
    micropost = Micropost.where(user_id: params[:id])
    login_user_micropost = Micropost.where(user_id: current_user.id)
    login_user_micropost = micropost
    login_user_micropost.user.id = current_user.id
    if login_user_micropost.save
      flash[:success] = "Micropost retweet!"
      redirect_to request.referrer
    else
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
      render 'static_pages/home'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :location, :password,
                                   :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end
end
