class UserMailer < ApplicationMailer
  default from: "gupta.rajat.be@gmail.com"

  def not_approved_email(user)
    @user = User.find(user)
    mail(to: @user.email, subject: 'Your Review Is Not Approved')
  end

  def review_date_email(review)
    @review = review
    @user = User.where.not(current_role: "admin")
    # @user.each do |e|
    # send_individual_email(e.email).deliver
    # end
  end

  def send_individual_email(email)
    mail(to: email, subject: 'Review Reminder')
  end

  def send_welcome_mail(email)
    mail(to: email, subject: 'Welcome')
  end
end
