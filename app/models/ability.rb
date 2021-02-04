class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = user.roles.pluck:name
      if user_role.include? "admin"
        can :manage, :all 
        cannot [:create, :update], Review
      end

      if user_role.include? "manager"
        can [:read], Question
        can [:update, :read, :show_reviews_of_user, :show], User
        can [:create, :update, :read], Review
      end

      if user_role.include? "employee" 
        can [:read], Question
        can [:update, :show], User
        can [:create, :update, :read], Review 
      end
    end
  end
end
