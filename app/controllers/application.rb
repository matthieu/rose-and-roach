require 'digest/sha1'

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  INDEX_PAGE = "/"
  
  init_gettext "htw"
  before_filter :check_cookie
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_htw_session_id'

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to INDEX_PAGE
  end

  def textilize(text)
    if text.blank?
      ""
    else
      textilized = RedCloth.new(text, [ :hard_breaks ])
      textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
      textilized.to_html
    end
  end

  # XmlHttpRequest calls that fail with an exception are by
  # default swallowed. They don't do anything on the client
  # side and no error gets logged on the serverside. This is
  # a wrapper to handle those with some sort of catch all.
  def ajax_wrap
    begin
      yield
    rescue Exception => e
      logger.error "An error occured during an AJAX call: #{e}"
      logger.error e.backtrace.join("\n")
    end
  end

  # Set the right column as hidden for pages rendering 
  # their own.
  def hide_column
    @hide_column = true
  end

  # Creates a paginator to display search results
  def pages_for(coll, total, params, options={})
    default_options = {:per_page => 10}
    options = default_options.merge options
    WillPaginate::Collection.create(params[:page]||1, options[:per_page]) do |pager|
      pager.replace(coll)
      pager.total_entries = total
    end
  end

  # Sets the language cookie
  def cookie_locale
    cookies["lang"] = params["lang"]
    redirect_to_index
  end

  # Generates a pseudo unique and pretty hard to break hash
  def pseudo_hash
    tf = Time.now.to_f
    Digest::SHA1.hexdigest(tf.to_s) + '~' + tf.to_s
  end

  # Checks whether a cookie is sent to eventually initialize a session
  def check_cookie
    if cookies[:user_hash] && session[:user_id].nil?
      user = User.find(:first, :conditions => ["cookie_hash = ?", cookies[:user_hash]])
      session[:user_id] = user.id
    end
  end

end

# When calling and ajax render :update, the provided block is executed
# by an isolated class that has no access to controllers methods. Therefore
# the only way to reuse code there is to add methods directly in the page
# object passed to the block.
module ActionView
  module Helpers
    module PrototypeHelper
      class JavaScriptGenerator
        # Displays a fading after an ajax call to the server
        def notice(msg)
          self["errorExplanation"].update("<div id=\"tmpNotice\" style=\"display: none;\">#{msg}</div>")
          visual_effect :appear, "tmpNotice", :duration=>0.5
          delay(7) do
            visual_effect :fade, "tmpNotice"
          end
        end
      end
    end
  end
end
