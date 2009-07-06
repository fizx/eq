class UsersController < ApplicationController
  skip_before_filter :login_required
  before_filter :setup_user
  before_filter :admin_or_current, :only => %w[edit update]
  # before_filter :show_friend_request, :only => "show"
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
      redirect_to @user
    else
      render :action => "edit"
    end
  end
  
  def show
  end
 
  def create
    @user = User.new(params[:user])
    if params[:invite_code] != "monkeys"
      flash[:notice] = "invalid invite code"
      redirect_to "/"
      return
    end
    if params[:fb_user]
      @user.fb_uid = facebook_user.uid
      @user.password = @user.password_confirmation = rand.to_s
    end
    logout_keeping_session!
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
private 
  def setup_user
    @user = User.find(params[:id]) if params[:id]
  end
  
  def show_friend_request
    if @user == current_user || @user.follows?(current_user)
      return true
    else
      render :action => "friend_request" 
      return false
    end
  end
  
  def admin_or_current
    if @user != current_user && !current_user.admin?
      redirect_to params.merge(:action => "show")
      return false
    else
      return true
    end
  end
end
