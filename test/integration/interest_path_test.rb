require File.dirname(__FILE__) + "/../test_helper"
require "webrat"
Webrat.configure do |config|
  config.mode = :rails
end

class InterestPathTest < ActionController::IntegrationTest
  include AuthenticatedTestHelper
  def setup
    @user = Factory(:user, :password => "hiworld", :password_confirmation => "hiworld")
    visit login_path
    fill_in "login", :with => @user.login
    fill_in "password", :with => "hiworld"
    click_button "Log in"
    assert_response :success
  end
  
  def test_activity_happy_path
    visit new_activity_path
    assert_response :success
    
    while request.path.starts_with?("/activ")
      assert_select "#ideas li a" do |links|
        click_link links.first.children.first.content
      end
    end
    
    assert_path interest_path(Interest.last)
  end

  def test_activity_tricky_path
    get new_activity_path
    fill_in "activity_name", :with => "Snorkeling"
    click_button "Go"
    click_link "Advanced"
    fill_in "time_span_start", :with => "6/26/09"
    fill_in "time_span_finish", :with => "6/29/09"
    click_button "Choose"
    fill_in "proximity_radius", :with => "20"
    fill_in "proximity_location_string", :with => "sf, ca"
    click_button "Choose"
    fill_in "group_size_min", :with => "1"
    fill_in "group_size_max", :with => "10"
    click_button "Choose"
    click_link "you know well"
    assert_path interest_path(Interest.last)
  end
  
  def assert_path(path)
    assert_equal request.path, path
  end
end
