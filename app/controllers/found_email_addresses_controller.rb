class FoundEmailAddressesController < ApplicationController
  layout "site"
  def index
    @addresses = current_user.found_email_addresses.paginate(:per_page => 100, :page => params[:page], :order =>"address")
  end
end
