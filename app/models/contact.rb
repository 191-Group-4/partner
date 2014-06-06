class Contact < MailForm::Base
  attribute :name
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w\-]+\.)\z/i
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    
    {
      :subject => "Bug Report",
      :to => "ryderc@uci.edu",
      :from => %("#{name}" <#{email}>)
    }

end
end