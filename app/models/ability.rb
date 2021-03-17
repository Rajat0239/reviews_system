class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = user.current_role
      if user_role == "admin"
        can :manage, :all 
        cannot [:create, :update, :read], Review
      end

      if user_role == "manager"
        can [:update, :read, :show_reviews_of_user, :show, :user_inventory_list, :asset_requests], User
        can [:create, :read, :show_reviews], Review
        can [:create, :read], FeedbackByReportingUser
        can [:read], QuestionForUser
        can [:read], Asset
      end

      if user_role == "employee" 
        can [:update, :show, :user_inventory_list, :asset_requests], User
        can [:create, :read, :show_reviews], Review 
        can [:read], FeedbackByReportingUser
        can [:read], QuestionForUser
        can [:read], Asset
      end
    end
  end
end
