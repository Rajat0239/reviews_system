class UserMailer < ApplicationMailer
  default from: "gupta.rajat.be@gmail.com"

  def not_approved_email(user)
    @user = User.find(user)
    #mail(to: @user.email, subject: 'Your Review Is Not Approved')
  end

  # def reprting_feedback_email(feedback)
  #   @employee = User.find(feedback.user_id)
  #   @reporter = User.find(feedback.feedback_for_user_id)
  #   @admin = User.find_by(current_role:"admin")
  #   # mail(to: @admin.email, subject: "Manager give feedback for employee respected review please check!")
  # end

  def employee_feedback_acknowledgement_mail(feedback_data)
    @employee_data = User.find(feedback_data)
    mail(to: @employee_data.email, subject: "Feedback for your respected review's please check!")
  end

  def review_date_email(review)
    @review = review
    @user = User.where.not(current_role: "admin")
    # @user.each do |e|
    # send_individual_email(e.email).deliver
    # end
  end

  def send_individual_email(email)
    #mail(to: email, subject: 'Review Reminder')
  end

  def send_welcome_mail(email)
    #mail(to: email, subject: 'Welcome')
  end

  def send_email_to_reporting_user(user)
    @user = user
    email = User.find(user.reporting_user_id).email
    #mail(to: email, subject: 'review submission by employee')
  end
end
