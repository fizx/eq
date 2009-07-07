class HidingsController < ApplicationController
  def create
    klass = Kernel.const_get(params[:hiding][:hidable_type])
    iid = params[:hiding][:hidable_id]
    object = klass.find(iid)
    if params[:unhide]
      @hiding = Hiding.find_by_user_id_and_hidable_id_and_hidable_type(current_user.id, iid, klass.to_s)
      @hiding.destroy
      render_update_item(object)
    else
      @hiding = Hiding.create(params[:hiding].merge(:user_id => current_user.id))
      render_update_hide_item(object)
    end
  end
end
