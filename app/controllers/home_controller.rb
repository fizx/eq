class HomeController < ApplicationController
  def index
    @question = "Do you want to 
      <br>#{Activity.all.rand.name} 
      <br>#{TimeSpan.all.rand.name} 
      <br>#{Proximity.all.rand.name}
      <br>with #{GroupSize.all.rand.name}
      <br>that #{Familiarity.all.rand.name}?"
  end
end
