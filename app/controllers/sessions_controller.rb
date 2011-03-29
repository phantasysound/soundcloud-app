class SessionsController < ApplicationController
  
  def new
    
    reset_session
    
    if params[:service] == "facebook"
    
      redirect_to oauth2_client.web_server.authorize_url(:redirect_uri => oauth_callback_url("facebook"), :scope => 'publish_stream')
    
    else
      
      request_token = oauth_consumer(params[:service]).get_request_token({:oauth_callback => oauth_callback_url(params[:service])})
      
      session[:request_token], session[:request_token_secret] = request_token.token, request_token.secret
      
      if params[:service] == "myspace"
      
        redirect_to request_token.authorize_url + "&oauth_callback="+CGI.escape(oauth_callback_url(params[:service])) + "&myspaceid.permissions=UpdateMoodStatus"
        
      else
        
        redirect_to request_token.authorize_url
        
      end
      
    end 
    
  end

  def oauth_callback
    
    if params[:service] == "facebook" # oauth2
      
      access_token = oauth2_client.web_server.get_access_token(params[:code], :redirect_uri => oauth_callback_url("facebook"))
      
      result = Crack::JSON.parse(access_token.get('/me'))
      
      session[:user] = {:service => "facebook", :token => access_token.token, :name => result["name"], :picture => "https://graph.facebook.com/#{result["id"]}/picture"}
      
    else # oauth
      
      request_token = OAuth::RequestToken.new(oauth_consumer(params[:service]), session[:request_token], session[:request_token_secret])
      
      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    
      session[:request_token], session[:request_token_secret] = nil
      
      if params[:service] == "myspace"
        
        result = Crack::JSON.parse(access_token.get('/v2/people/@me/@self?format=json').body)["entry"]
        
        session[:user] = {:service => "myspace", :token => access_token.token, :secret => access_token.secret, :name => result["displayName"], :picture => result["thumbnailUrl"] || "http://x.myspacecdn.com/modules/common/static/img/no_pic.gif"}
      
      elsif params[:service] == "digg"
        
        result = Crack::JSON.parse(access_token.get('http://services.digg.com/2.0/user.getInfo').body)["user"]
        
        session[:user] = {:service => "digg", :token => access_token.token, :secret => access_token.secret, :name => result["username"], :picture => result["icon"] || "http://cdn4.diggstatic.com/img/user/p.a83ec048.png"}
      
      elsif params[:service] == "twitter"
        
        result = Crack::JSON.parse(access_token.get('/account/verify_credentials.json').body)
        
        session[:user] = {:service => "twitter", :token => access_token.token, :secret => access_token.secret, :name => result["name"], :picture => result["profile_image_url"]}
        
      elsif params[:service] == "soundcloud"
        
        track_url = access_token.get("/resolve?url=#{SETTINGS["track"]}")["location"]
        
        if track_url
        
          track_user_id = Crack::JSON.parse(access_token.get("#{track_url}.json").body)["user"]["id"]
        
          user_id = Crack::JSON.parse(access_token.get('/me.json').body)["id"]
        
          if user_id == track_user_id
          
            flash[:notice] = "You have successfully connected with SoundCloud."
            
            session[:user] = {:service => "soundcloud"}
          
            Settings.token, Settings.secret = access_token.token, access_token.secret
          
          else
          
            flash[:error] = "You are not the owner of the track specified in config.yml."
          
          end
          
        else
          
          flash[:error] = "You do not have access to the track specified in config.yml."
          
        end
        
      end
      
    end
    
    redirect_to root_path
    
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end