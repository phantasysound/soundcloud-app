class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery
  
  protected
  
  # OAUTH
  
  def oauth_consumer(service)
    
    if service == "myspace"
      
      @oauth_consumer ||= OAuth::Consumer.new(config[service]['key'], config[service]['secret'], :site => config[service]['base_url'],
        :http_method => "get",
        :request_token_path => "/request_token",
        :access_token_path => "/access_token",
        :authorize_path => "/authorize"
      )
      
    elsif service == "digg"
      
      @oauth_consumer ||= OAuth::Consumer.new(config[service]['key'], config[service]['secret'], :site => config[service]['base_url'],
        :request_token_url => "http://services.digg.com/oauth/request_token",
        :access_token_url => "http://services.digg.com/oauth/access_token"
      )
      
    else
   
      @oauth_consumer ||= OAuth::Consumer.new(config[service]['key'], config[service]['secret'], :site => config[service]['base_url'])
      
    end
      
  end
  
  def oauth_token(service)
    
    if service == "soundcloud"
      @oauth_token ||= OAuth::AccessToken.new(oauth_consumer(service), Settings.token, Settings.secret)
    else
      @oauth_token ||= OAuth::AccessToken.new(oauth_consumer(service), session[:user][:token], session[:user][:secret])
    end
    
  end
  
  # OAUTH 2
  
  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(config['facebook']['app_id'], config['facebook']['secret'], :site => config['facebook']['base_url'])
  end
  
  def oauth2_token
    @oauth2_token ||= OAuth2::AccessToken.new(oauth2_client, session[:user][:token])
  end
  
  # CONFIG
  
  def config
    config = YAML.load(File.open(RAILS_ROOT + '/config/auth.yml').read)[RAILS_ENV]
  end
  
end
