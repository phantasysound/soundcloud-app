class PostsController < ApplicationController
  
  def new
    
  end

  def create
    
    @post = params[:post]
    
    if @post["service"] == "facebook"
      
      oauth2_token.post('/me/feed', {
        :message => @post["text"], 
        :picture => "#{root_url}images/artwork.jpg",
        :link => root_url,
        :source => "http://p1.soundcloud.com/player.swf?url="+SETTINGS["track"]+SETTINGS["player"]["params"]+"&player_type="+SETTINGS["player"]["type"]+"&default_width=259&default_height=259&auto_play=true",
        :name => SETTINGS["title"],
        :caption => root_url,
        :description => SETTINGS["description"]
      })  
      
    elsif @post["service"] == "twitter"
      
      oauth_token("twitter").post('/statuses/update.json', {:status => @post["text"]})
      
    elsif @post["service"] == "digg"
      
      @story = Crack::JSON.parse(oauth_token("digg").get("http://services.digg.com/2.0/story.getInfo?links=#{root_url}").body)["stories"][0]
      
      if @story
      
        oauth_token("digg").get("http://services.digg.com/2.0/story.digg", {'story_id' => @story["story_id"]})
        
        if not @post[:text].empty? && @post[:text] != "Leave a Comment..."
          oauth_token("digg").post("http://services.digg.com/2.0/comment.post", {'story_id' => @story["story_id"], 'comment_text' => @post[:text]})
        end
        
      end
      
    elsif @post["service"] == "myspace"
      
      result = Crack::JSON.parse(oauth_token("myspace").get('/v1/user.json').body)

      oauth_token("myspace").post("/v1/users/#{result["userId"]}/status", {'status' => @post[:text]}, {'X-HTTP-Method-Override' => 'PUT'})
      
    end
    
    # Create new user with Service, Name, Location ...
    
    session[:download] = true
    
    redirect_to root_path
    
  end
  
  def download
    
    if session[:download]
      redirect_to oauth_token("soundcloud").get("#{SETTINGS["track"]}/download")["location"]
    else
      redirect_to root_path
    end
    
  end

end