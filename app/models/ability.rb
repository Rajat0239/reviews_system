class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = user.current_role
      if user_role == "admin"
        can :manage, :all 
        cannot [:create, :update, :read], Review
        cannot [:create, :destroy], AssetRequest
      end

      if user_role == "manager"
        can [:update, :read, :show_reviews_of_user, :show, :user_inventory_list], User
        can [:create, :read, :show_reviews], Review
        can [:create, :read], FeedbackByReportingUser
        can [:read], QuestionForUser
        can [:read], Asset
        can [:create, :read, :destroy], AssetRequest        
      end

      if user_role == "employee" 
        can [:update, :show, :user_inventory_list], User
        can [:create, :read, :show_reviews], Review 
        can [:read], FeedbackByReportingUser
        can [:read], QuestionForUser
        can [:read], Asset
        can [:create, :read, :destroy], AssetRequest
      end
    end
  end
end
