class ChangeMailer < ActionMailer::Base
  default from: "ryderc@uci.edu"

 def send_change_message(user)
    mail(:to => user, :subject => "A change has been made to your Partner Up account")
  end
end
