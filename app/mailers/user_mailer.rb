class UserMailer < ActionMailer::Base
  default from: "webmaster@myapp.com"

  def send_mail(user)
    @user = user
    mail(:to => user.email,
         :subject => "You have been Invited!")
  end
end