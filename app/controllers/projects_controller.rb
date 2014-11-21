class ProjectsController < ApplicationController
  include UsersHelper, GroupsHelper
  
  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def new
  end
  
  def create
    @project = Project.new(project_params)
    
    if @project.save
    relation = ProjectRelation.create(course_id: params[:project][:course_id], project_id: @project.id)
    relation.save
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end
  
  def edit
    @project = Project.find(params[:id])

  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    @project.save
    ProjectRelation.find_by(project_id: params[:id]).destroy
    redirect_to(:action => 'index')
  end

  def update
    @project = Project.find(params[:id])
    
    if @project.update_attributes(project_params)
      if ProjectRelation.find_by(project_id: @project.id).nil?
        relation = ProjectRelation.create(course_id: params[:project][:course_id], project_id: @project.id)
        relation.save
      else
    ProjectRelation.find_by(project: @project.id).update_attributes(course_id: params[:project][:course_id], project_id: @project.id)
      end
      flash[:notice] = "Project updated successfully"
      redirect_to(:action => 'index')
    else
      flash[:error] = "Project could not be updated"
      render('edit')
    end
  end

    def autogroup
    students, groups = [], []
    @project = Project.find(params[:id])
      @project.course.users.each do |user|
        if User.find(user).role == 0 && GroupRelation.where(user_id: user, project_id: @project).empty?
        students.push(user)
        end
      end

    while !students.empty?
     group_namer(params[:project][:name_gen])
     newgroup = Group.create(name: @groupname, project_id: @project.id,course_id: @project.course_id)
     students.sample(@project.group_size).collect(&:id).each do |student|
        GroupRelation.create(course_id: @project.course_id, group_id: newgroup.id, user_id: student, project_id: @project.id)
        groups.push(student)
        students.delete_if{ |student| groups.include?(student.id)}
      end
    end

flash[:notice] = "Groups have been randomly assigned for <b>#{@project.name}</b>"
redirect_to groups_path
end


  def remove
    @project = Project.find(params[:id])
    @project.destroy
    if @project.save
      flash[:notice] = "Project Deleted"
    else
      flash[:error] = "Project could not be deleted"
    end
    redirect_to(:action => 'index')
  end

  def clear_partnerships
    user = User.find(params[:id])
    authorize user
    set_current_users_instance_variables
    if !@myproject.nil?
    Group.where(project_id: @myproject).each do |proj|
      proj.destroy
    end
    GroupRelation.where(project_id: @myproject).each do |proj|
      proj.destroy
    end
      flash[:notice] = "All Groups and Partnerships were cleared."
    else 
      flash[:error] = "Unable to clear group relations."
    end
  redirect_to :back
  end

  
  private 
  
  def project_params
    params.require(:project).permit(:name, :active, :autogroup, :course_id, :group_size, :allow_repeat, :name_gen)
  end 
  
end