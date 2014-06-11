class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def profile?
    true
  end

  def update?
    true
  end

  def confirm?
    true
  end

  def destroy?
    true
  end

  def flop?
    # So long as both current user and the user being requested are unpartnered
    ((user.status == false && record.status == false) && 
    
    # AND the person isn't partnering with themselves....
    (user.name!=record.name) && (user.user? && record.user?)) ||

     # OR their partner1's are not each others names, (if they are each other's partners)
    (user.partner1 == record.name && record.partner1 == user.name)
  end

  def clearall?
    # as long as the user is an admin or vip role , 1||2
    user.admin? || user.vip?
  end

  def cancel?
    true
  end

  def export?
    # as long as the user is an admin or vip role , 1||2
    user.admin? || user.vip?
  end

  def clearpartnership?
    true
  end

end
