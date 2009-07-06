class FacebookController < ApplicationController
  skip_before_filter :login_required
  
  def authenticate
    if current_user = User.find_or_create_by_fb_uid(facebook_user.uid)
      flash[:notice] = "You have logged in via Facebook."
    else
      flash[:notice] = "Something went wrong."
    end  
    redirect_to "/"
    
  end
  
  def preview
  end
  
  def reclaim
  end
  
  def post_remove
  end
  
  def post_authorize
    if linked_account_ids = params[:fb_sig_linked_account_ids].to_s.gsub(/\[|\]/,'').split(',')
      linked_account_ids.each do |user_id|
        if user = User.find_by_id(user_id)
          user.update_attribute(:fb_uid, params[:fb_sig_user])
        end
      end
    end

    render :nothing => true
  end

end


