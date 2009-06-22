require "nokogiri"
class FriendsController < ApplicationController
  def find
    if params[:emails]
      @emails = params[:emails].split(/[,;\s]+/)
    elsif session[:token]
      client = GData::Client::Contacts.new
      client.authsub_token = session[:token]
      atom = client.get("http://www.google.com/m8/feeds/contacts/default/full")
      logger.info atom.body
      @emails = GmailParser.new.parse(atom.body)
    end
    if @emails
      @users = User.find_any_email @emails
    end
  end
  
  def gmail
    client = GData::Client::Contacts.new
    client.authsub_token = params[:token] # extract the single-use token from the URL query params
    session[:token] = client.auth_handler.upgrade()
    client.authsub_token = session[:token] if session[:token]
    redirect_to :action => "find"
  end

end
