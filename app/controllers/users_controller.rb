class UsersController < ApplicationController
  include UsersHelper
  helper_method :course_ids, :requested?, :my_partner_for, :requester?, :teammates?, :in_group_for?, :classmates?, :same?, :is_student?, :user_netid
  before_filter :authenticate_user!
  # after_action :verify_authorized, except: [:show, :index]
  require 'csv'
   
  def index
    # @user = User.find(params[:id])
    set_current_users_instance_variables
    
    if @myproject.nil?
      set_current_project_course(current_user, Project.find(0), Course.find(0))
    end
      # @allowed_project_size = @myproject.group_size
  end

  def new
    user = User.find(params[:id])
    authorize user
  end

  def show
    @user = User.find(params[:id])
    if user_signed_in?
      authorize @user
    else
    redirect_to :back, :alert => "Access denied."
    end
  end

  def profile
    if user_signed_in?
    authorize current_user
    else
    redirect_to :back, :alert => "Access denied."
    end
  end

  def update
    user = User.find(params[:id])
    authorize user
    if user.update_attributes(secure_params)
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
  
  def set_current_course
    authorize User.find(params[:id])
    set_current_users_instance_variables
    current_user.update_attributes(secure_params)
    
    if @current_projects.exists?
      current_user.update_attributes(current_project: @current_projects.first.id)
    end
    redirect_to users_path
      
  end
  
  def set_current_project
    user = User.find(params[:id])
    authorize user
    current_user.update_attributes(secure_params)
    redirect_to users_path
  end

  # Start download of csv file of partner data
  def export_csv
      user = User.find(params[:id])
      authorize user
      roster_csv = CSV.generate do |csv|
      csv << ["First Name", "Last Name", "Email"]
      User.where(role: 0).each do |user|
        csv << [user.first_name, user.last_name, user.email]     
      end 
      end    
    send_data(roster_csv, :type =>  'text/csv', :filename =>  'groups.csv')
  end

  def send_request
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
   
    if @current_group_size >= @allowed_group_size
      flash[:error] = "Unable to send request, you have too many pending requests."
    elsif @allowed_group_size == 2
      request_partner(user)
    elsif @allowed_group_size >= 2
      request_group_member(user)
    else
      flash[:notice] = "Your Professor specified this project is an individual task. If this is incorrect, please contact your professor. "
    end
    redirect_to users_path
  end

   def undo_request
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
    if !@mygroup.nil?
    GroupRelation.where(project_id: @myproject.id, user_id: user.id, group_id: @mygroup.id, status: 1).first.destroy
    # Delete relation for user
    
    if @current_group_size <= 2
    # Delete the group
    @mygroup.destroy
    # Delete relation for current user
    GroupRelation.where(project_id: @myproject.id, user_id: current_user.id, group_id: @mygroup.id, status: 2).first.destroy
    end
    flash[:error] = "Successfully removed request"
    end
  redirect_to users_path
  end

  def confirm
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
    allowed_group_size = Project.find_by_id(current_user.current_project).group_size
    
    if allowed_group_size == 2
      confirm_partner(user)
    elsif allowed_group_size >= 2
      confirm_group_member(user)
    else
    flash[:notice] = "Your Professor specified this project is an individual task. If this is incorrect, please contact your professor. "
       redirect_to users_path
    end
  end
  
  def ignore
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
    if !@mygroup.nil?
    if GroupRelation.where(group_id: @mygroup.id).size <= 2
    # Delete the group
    @mygroup.destroy
    # Delete relation for current user
    GroupRelation.where(user_id: requester?(user).id, group_id: @mygroup.id, status: 2).first.destroy
    
  
    # Delete relation for user
    flash[:notice] = "Removed request."
    else 
    flash[:error] = "Unable to remove request."
    end
    GroupRelation.where(user_id: requested?(user).id, group_id: @mygroup.id, status: 0).first.destroy
  end
    redirect_to users_path
  end

  def delete_partnership
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
    if !@mygroup.nil?
      if @current_group_size <= 2
        # Delete the group
        @mygroup.destroy
        # Delete relation for current user and user
        GroupRelation.find_by(user_id: current_user.id, group_id: @mygroup.id).destroy
        # Delete relation for user
      end
      GroupRelation.find_by(user_id: user.id, group_id: @mygroup.id).destroy
      flash[:notice] = "Removed User."
    else 
      flash[:error] = "Unable to remove user."
    end
  redirect_to users_path
  end


  private
  def login_params
    params.require(:user).permit(:id)
  end
  def secure_params
    params.require(:user).permit(:id, :name, :ucinetid, :role, :current_course, :current_project)
  end
end
