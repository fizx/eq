require "nokogiri"
require "will_paginate"
class FriendsController < ApplicationController
  def index
    @friends = current_user.followees.paginate(:page => params[:page])
    if @friends.empty?
      flash[:notice] = "You haven't listed any friends yet.  Let's find some!"
      redirect_to :action => "find"
    end
  end
  
  def find
    if params[:emails]
      @emails = params[:emails].split(/[,;\s]+/)
    elsif session[:token] && !session[:parsed_gmail]
      client = GData::Client::Contacts.new
      client.authsub_token = session[:token]
      @emails = GmailParser.new(client).parse("http://www.google.com/m8/feeds/contacts/default/full")
      session[:parsed_gmail] = true
    end
    current_user.add_found_emails(@emails)

    @users = current_user.weak_followees.find_any_email @emails    
    @invites = @users.first(5)
  end
  
  def gmail
    client = GData::Client::Contacts.new
    client.authsub_token = params[:token] # extract the single-use token from the URL query params
    session[:token] = client.auth_handler.upgrade()
    client.authsub_token = session[:token] if session[:token]
    redirect_to :action => "find"
  end

end
