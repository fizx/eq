require "gdata" 
module FriendsHelper
  def gmail_link
    return "" if session[:token]
    client = GData::Client::Contacts.new
    next_url = 'http://localhost:3000/friends/gmail'
    secure = false
    sess = true
    authsub_link = client.authsub_url(next_url, secure, sess)
    link_to "Look in GMail Contacts!", authsub_link
  end
end
