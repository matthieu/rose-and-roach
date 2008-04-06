class LoginController < ApplicationController

  def login
    session[:user_id] = nil
    if request.post?
      # Checking authentication
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        session[:user_id] = user.id
        # Is this a redirect from a login only page?
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || INDEX_PAGE)
      else
        flash[:notice] = _("Invalid user/password combination")
      end
    end
  end

  def register
    @user = User.new(params[:user].merge({:role => :user}))
    if request.post? and @user.save
      # TODO send confirmation e-mail
      session[:user_id] = @user.id
      redirect_to_index(_("You've been registered (and logged in) successfully, %s. A confirmation e-mail will be sent to you shortly.") % @user.fullname) 
    else
      # voiding the typed password
      @user.password = nil
      render :action => :login
    end
  end

  def logout
    @user = User.find_by_id(session[:user_id])
    session[:user_id] = nil
    redirect_to_index(_("You've been succesfully logged out, %s. We hope to see you again soon.") % @user.fullname)
  end
end
