class UserMailer < ActionMailer::Base
  default from: "noreply@jake0oo0.me"

  def send_mail(user)
    @user = user
    mail(:to => user.email,
         :subject => "You have been Invited!")
  end
end