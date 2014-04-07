include LoginHelper

class LoginController < ApplicationController

  def index

 # If we're viewing this unauthenticated, set our goback URL for after logging in
    if session[:user_id].nil?
      session[:return_from_saml_url] = request.url
      #generate a random ID and store in Sessions table
      session[:remember_token] = SecureRandom.uuid
      return redirect_to(controller: '/saml')
    end


    respond_to do |format|
      format.html # index.html.erb
    end

  end
end
