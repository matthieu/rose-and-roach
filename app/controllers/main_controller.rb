class MainController < ApplicationController

  def set_lang
    code = params[:id]
    cookies[:lang] =
      {
      :value => code,
      :expires => Time.now + 1.year,
      :path => '/'
    }
    redirect_to_index
  end
end
