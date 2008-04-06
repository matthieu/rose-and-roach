class PledgeController < ApplicationController

  ACTIONS_COUNT = 10

  around_filter :ajax_wrap, :only => [:set]

  def list
    user_pledges = []
    if (session[:user_id])
      @user = User.find_by_id(session[:user_id])
      user_pledges = @user.pledges.map { |p| p.action_id }
    end

    condition = "classifier > 0 and classifier <= #{ACTIONS_COUNT+user_pledges.size}"
    condition << " and id not in (#{user_pledges.join(',')})" unless user_pledges.empty?
    @actions = Action.find(:all, :conditions => condition, :order => "classifier ASC")
  end

  def set
    # If the user isn;t logged we need to create an empty account and
    # associate it with a cookie.
    unless session[:user_id]
      hash = pseudo_hash
      user = User.new(:cookie_hash => hash)
      user.save
      cookies[:user_hash] = hash
      session[:user_id] = user.id
    end
    
    status = (params[:do] == 'accept') ? 1 : 2
    # Save new pledge
    pledge = Pledge.new(:user_id => session[:user_id], 
                        :action_id => params[:id], :status => status)
    pledge.save!

    # Gets the next action proposal
    @user = User.find_by_id(session[:user_id])
    @action = Action.find(:all, 
        :conditions => ["classifier = ?", @user.pledges.size + ACTIONS_COUNT]).first

    # Should get the next take action project
    render :update do |page|
      page.remove("div_action_#{params[:id]}")
      page.insert_html(:bottom, 'div_action_list', :partial=>'action') if @action
      page.notice _("Thanks for pledging for this action, please confirm it in your profile when it's done.")
    end
  end
end
