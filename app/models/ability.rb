class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = user.roles.pluck:name
      if user_role.include? "admin"
        can :manage, :all 
        cannot [:create, :update, :read], Review
      end

      if user_role.include? "manager"
        # can [:read], Question
        can [:update, :read, :show_reviews_of_user, :show], User
        can [:create, :read, :show_reviews], Review
        can [:create, :read], FeedbackByReportingUser
        can [:read], QuestionForUser
        
      end

      if user_role.include? "employee" 
        # can [:read], Question
        can [:update, :show], User
        can [:create, :read, :show_reviews], Review 
        can [:read], FeedbackByReportingUser
        can [:read], QuestionForUser
      end
    end
  end
end
