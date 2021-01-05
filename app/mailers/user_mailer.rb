class UserMailer < ApplicationMailer
  default from: "rajat.gupta290998@gmail.com"
  def sample_email(user)
    #byebug
    #@user = User.find(user.user_id)
    #@email = "anurajamma01@gmail.com"0
    mail(to: "rajat.gupta.sbg@gmail.com", subject: 'Your Review Is Not Approved')
  end
end
