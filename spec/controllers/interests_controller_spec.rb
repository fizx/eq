require File.dirname(__FILE__) + '/../spec_helper'

describe InterestsController do
  before do 
    @user = Factory(:user)
    login_as @user
    @interest = Factory(:interest)
  end
  
  
end
