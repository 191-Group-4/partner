class ChangeMailer < ActionMailer::Base
default :from => 'partnerupuci@uci.edu'
 def send_change_message(user)
    mail(:to => user, :subject => "Your Partnership Status has changed")
  end
  #handle_asynchronously :send_change_message
end
