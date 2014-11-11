class CoursePolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def remove?
    true
  end

  def update?
    true
  end

end
