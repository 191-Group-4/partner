class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if (request.ip != "127.0.0.1" || @authkey == nil) && @campus_id!=current_user.id
    if User.where(:ucinetid => @ucinetid) !=nil
    User.where(:ucinetid => @ucinetid).update_all(:id => @campus_id, 
      :age_in_seconds => @age_in_seconds, :uci_affiliations => @uci_affiliations)
    current_user.save
    end
    end
    current_user.save
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
