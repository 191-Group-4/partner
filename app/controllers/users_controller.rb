class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:show]
require 'csv'

def index
  @users = User.all
  #@user = User.find(params[:id])
  authorize @users
end
def new
  @partners = User.find(params[:id])
  @users = User.all
  #@user = User.find(params[:id])
  authorize @users
end
def show
  @user = User.find(params[:id])
  unless user_signed_in?
# unless @user == current_user
  authorize @user
  redirect_to :back, :alert => "Access denied."
  end
end

def profile
  #unless user_signed_in?
# unless @user == current_user
  @users = current_user
  authorize @users
  #redirect_to :back, :alert => "Access denied."
end

def update
  @user = User.find(params[:id])
  authorize @user
  if @user.update_attributes(secure_params)
    redirect_to users_path, :notice => "User updated."
  else
    redirect_to users_path, :alert => "Unable to update user."
  end
end

def destroy
  user = User.find(params[:id])
  authorize user
  unless user == current_user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  else
    redirect_to users_path, :notice => "Can't delete yourself."
  end
end

# If the user is partnered, it will clear the partnership of the current_user and the partner
# If the user is unpartnered, it will partner them
# Partnering sets status to 1 or true and fills the current_user (and their partner's) partner1 with the other person's name
def flop
  user = User.find(params[:id])
  authorize user
  if current_user.role == "user"
  user.status = !user.status # flop the status
  current_user.status = !current_user.status

  if current_user.partner1 == ""

    current_user.partner1 = user.name
    user.partner1 = current_user.name
  else

    current_user.partner1 = ""
    user.partner1 = ""
  end

    user.save
    current_user.save
    redirect_to users_path(current_user)
    # Delay Mailer to reduce flop lag
    #ChangeMailer.delay.send_change_message(user.email)
    # Regular Mailer no delay
    
end
ChangeMailer.send_change_message(user.email).deliver
end

# Cancels account and ensures partnerships are cleared
def cancel
  user = User.find(params[:id])
  authorize user
  user.status = false
  current_user.status = false
  current_user.partner1 = ""
  user.partner1 = ""

  user.save
  current_user.save
  redirect_to registration_path(user)
  current_user.destroy

end

# Force clear partnership in case of database inconsistency
def clearpartnership
  user = User.find(params[:id])
  authorize user
  current_user.status = false
  current_user.partner1 = ""
  current_user.save

  redirect_to users_path(user)
end

# Clear all users partner1 columns to "" and reset statuses to 0 or false
def clearall
  User.all.each do |user|
    user = User.find(user)
    authorize user
    user.status = false
    user.partner1 = ""
    user.save
end
  redirect_to users_path(current_user), :alert => "All Partnerships have been cleared."
end

# Start download of csv file of partner data
def export
    authorize User.all
    @roster = User.all
    roster_csv = CSV.generate do |csv|
    csv << ["Name", "Partner"]
    User.where(role: 0).each do |user|
      csv << [user.name, user.partner1]     
    end 
    end    
  send_data(roster_csv, :type => 'text/csv', :filename => 'partnerships.csv')
end

def confirm
    time = Time.new
    user = User.find(params[:id])
    authorize user
    user.confirmed_at = time.strftime("%Y-%m-%d %H:%M:%S")
    user.save
    redirect_to users_path(current_user), :flash => { :success => "User Confirmed" }
end

def deleteavatar
authorize User.all
@user.avatar = nil
@user.save
end

  private
  def secure_params
    params.require(:user).permit(:role)
  end
end
