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
    url = request.protocol + request.host_with_port + request.relative_url_root + request.path
    response = consumer.complete(params.reject { |k, v| k !~ /^openid\./ }, url)
    if response.status == :success
      session[:url] = response.identity_url
      redirect_to snippets_path
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