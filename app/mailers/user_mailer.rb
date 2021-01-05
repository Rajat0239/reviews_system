class UserMailer < ApplicationMailer
  default from: "rajat.gupta290998@gmail.com"
  def sample_email(user)
    @user = User.find(user.user_id)
    mail(to: @user.email, subject: 'Your Review Is Not Approved')
  end
end
