# Implements the basic restriction rules to allow (or 
# disallow) access of a controller for a given user.
# The access is based on a role / permission mechanism.
# A user has a role, the role has a set of permissions
# and the access of a given controller action requires
# permissions.
#
# To restrict the usage of your controller you must 
# first inherit from RestrictedController. Restrictions
# are then defined by calling the RestrictedController#restrict
# method, providing the permissions required and 
# eventually the actions they apply on (same as a 
# Rails standard filters).
#
# For example:
#
# restrict :permission => :project_create, :only => :new
#
# Restrictions can also be applied on an object related
# to the user, the restriction will then make sure that
# the user is directly related to this object.
#
# For example:
#
# restrict :permission => :project_edit, :on_type => 'project', 
#          :except => [:new, :view]
#
# This will check that the project that is going to be
# accessed (found by using params[:id]) is related to
# the current user using either the User#project or
# User#projects relationships.
#
class RestrictedController < ApplicationController
  
  # Defines access restrictions based on permissions.
  class << self
    def restrict(params)
      before_filter(params) do |contr|
        contr.check_auth(params[:permission], params[:on_type] ? params[:on_type].to_s : nil)
      end
    end
  end

  # Checks whether the logged user has the required permissions.
  def check_auth(permission, on_type)
    # Looks like nobody's logged in
    unless session[:user_id] : login_needed; return 1; end

    @user = User.find_by_id(session[:user_id])
    unless @user : login_needed; return 1; end

    # Checking user's authorizations
    role = @user.role

    # Admin has them all
    return 1 if role == :admin

    has_perm = User::PERMISSIONS[role].include?(permission)
    puts "Has permissions: #{has_perm}"
    if on_type
      if on_type == 'self'
        reject unless params[:id] == @user.id.to_s
      else
        # Could be related as a singular or plural
        type_meth = on_type if @user.respond_to?(on_type)
        type_meth = on_type.pluralize if @user.respond_to?(on_type.pluralize)
        puts "Checking relation to #{type_meth} id #{params[:id]}"
        raise(ArgumentError, "No accessor for #{on_type} in user object.") unless type_meth
        # Getting the related object(s)
        related = @user.send(type_meth)
        
        # Getting the object the action is supposed to access
        req_obj = instance_variable_set(('@'+on_type).to_sym, 
        on_type.camelize.constantize.find(params[:id]))
        
        # Do we have a match?
        reject unless has_perm && (req_obj == related || related.include?(req_obj))
      end
    else
      reject unless has_perm
    end
  end

  def login_needed
    session[:original_uri] = request.request_uri
    flash[:notice] = _("To access this page you will need to login, we just need to know a bit more about you.")
    redirect_to(:controller => "login" , :action => "login" )
  end

  def reject
    flash[:notice] = "You're not allowed to execute this action."
    redirect_to_index
  end

end
