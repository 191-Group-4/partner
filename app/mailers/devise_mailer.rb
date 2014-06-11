class DeviseMailer < ActionMailer::Base 

 helper :application # gives access to all helpers defined within `application_helper`.
 include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
 include Devise::Mailers::Helpers

   def confirmation_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
      mail(to: @user.email, subject: 'Confirmation Instructions for Partner Up')
    end

    def reset_password_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :reset_password_instructions, opts)
      mail(to: @user.email, subject: 'Reset Password Instructions for Partner Up')
    end

    def unlock_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
      mail(to: @user.email, subject: 'Account Unlock Instructions for Partner Up')
    end
end