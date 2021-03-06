require 'openid/store/filesystem'

class SessionsController < ApplicationController
  # login page
  def new
  end

  # login form submission
  def create
    store = OpenID::Store::Filesystem.new(RAILS_ROOT + '/tmp')
    consumer = OpenID::Consumer.new(session, store)
    oid_req = consumer.begin params[:url]
    realm = request.protocol + request.host_with_port
    return_to = session_url
    redirect_to oid_req.redirect_url(realm, return_to)
  end
  
  def show
    if params['openid.mode']
      # the openid provider sends the browser back here
      # we'd rather use the update method because it's more RESTful
      update
    else
      redirect_to new_session_path
    end
  end
  
  # back from openid provider
  def update
    store = OpenID::Store::Filesystem.new(RAILS_ROOT + '/tmp')
    consumer = OpenID::Consumer.new(session, store)
    response = consumer.complete(params.reject { |k, v| k !~ /^openid\./ }, session_url)
    if response.status == :success
      # Awesome! Set the user identity url in the session
      session[:url] = response.identity_url
      # redirect somewhere useful
      redirect_to '/'
    else
      flash[:notice] = 'Failure signing in with OpenID.'
      redirect_to new_session_path
    end
  end

  # sign out
  def destroy
    session[:url] = nil
    redirect_to new_session_path
  end
end