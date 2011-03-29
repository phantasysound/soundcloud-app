class UsersController < ApplicationController

  def index
    
    if session[:user] && session[:user][:service] == "soundcloud"

      @users = User.all
      
      csv_string = FasterCSV.generate do |csv|

        csv << ["Email"]

        @users.each do |user|
          csv << [user.email]
        end
        
      end

      send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=emails.csv"
      
    else
      
      redirect_to login_path("soundcloud")
      
    end
    
  end
  
  def create
    
    @user = User.new(params[:user])

    if @user.save
      session[:download] = true
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to root_path
    end
    
  end
  
end
