class UserMailer < ActionMailer::Base
  default from: "noreply@jake0oo0.me"

  def contact(user)
    @user = user
    mail(:to => 'jake0oo0andminecraft@gmail.com',
         :subject => "Inquiry from #{@user.username}"
         :reply_to => @user.email)
  end
end