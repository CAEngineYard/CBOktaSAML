require 'onelogin/ruby-saml/settings.rb'
require 'onelogin/ruby-saml/authrequest.rb'
require 'onelogin/ruby-saml/response.rb'

class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume]

  def index
    # insert identity provider discovery logic here
    settings = Account.get_saml_settings
    request = Onelogin::Saml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def consume

    response = Onelogin::Saml::Response.new(params[:SAMLResponse])

    # insert identity provider discovery logic here
    response.settings = Account.get_saml_settings

    logger.info "NAMEID: #{response.name_id}"
    puts response.is_valid?
    if response.is_valid?
      session[:user_id] = response.name_id
      puts "Session[:user_id: " + session[:user_id]
      puts "Session[:return_from_saml_url]"+  session[:return_from_saml_url]
      if session[:return_from_saml_url].nil?
        return redirect_to '/security_tags'
      end
      redirect_to session[:return_from_saml_url]
    else
      redirect_to :action => :fail
    end
  end
  def show

  end

  def complete

  end

  def fail
  end
end
