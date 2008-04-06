class UserController < RestrictedController

  around_filter :ajax_wrap, :only => [:confirm]
 
  # Home and profile don't need to be restricted as they only consider the session user id
  restrict :permission => :user_edit, :on_type => 'pledge', :only => :confirm

  before_filter :user_menu, :except=>"confirm"

  def home
    @pledges = Pledge.find(:all, :conditions => ["user_id = ? and status = 1", session[:user_id]])
  end

  def profile
    if request.post?
      user_h = params[:user]
      if user_h["password"].empty?
        user_h.delete("password")
        user_h.delete("password_confirmation")
      end
      @user = User.update(session[:user_id], user_h)
      flash[:notice] = _("Your profile has been correctly updated.") if @user.errors.empty?
      # Reloading to make sure everything's fine
      redirect_to :action=>:profile
    end
    @user.password = ""
  end

  def confirm
    @pledge.status = Pledge::STATUS[:confirmed]
    @pledge.save
    home
    render :update do |page|
      page.remove("confirm_pledge_#{@pledge.id}")
      page.notice("The action has been successfully confirmed. Thanks!")
      page.replace_html "pledge_text", 
        _("You have %s %s to confirm.") % [fuzzy_num(@pledges.size), pluralize(@pledges.size, _("pledge"))]
    end
  end

private

  def user_menu
    redirect_to_index unless session[:user_id]
    @hide_column = true
    @user = User.find(session[:user_id])
  end

end
