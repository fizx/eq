class FoundEmailAddressesController < ApplicationController
  layout "site"
  def index
    @addresses = current_user.weak_followees.paginate(:per_page => 100, :page => params[:page], :order => "email")
  end
end
