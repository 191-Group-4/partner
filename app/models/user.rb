class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
#, :lockable, :timeoutable and :omniauthable   
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  enum role: [:user, :vip, :admin]
  #user = student
  #vip = Professor
  #admin = admin
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end



end
