class HomeController < ApplicationController
  def index
    @interest = Interest.random
    @question = "Do you want to " + @interest.description + "?"
  end
end
