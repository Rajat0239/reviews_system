class UserMailer < ApplicationMailer
  default from: "rajat.gupta290998@gmail.com"
  def not_approved_email(user)
    @user = User.find(user.user_id)
    mail(to: @user.email, subject: 'Your Review Is Not Approved')
  end
  def review_date_email(review)
    @review = review
    @user = User.where.not(current_role: "admin")
    # @user.each do |e|
    #   send_email(e.email).deliver
    # end
  end
  def send_email(email)
    mail(to: email, subject: 'Review Reminder')
  end
end
