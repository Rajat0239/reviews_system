class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      #byebug
      user_role = user.roles.pluck:name
      if user_role.include? "admin"
        can :manage, :all 
        cannot [:create, :update], Review
      end
      if user_role.include? "manager"
        can [:update, :read] , Review
      end
      if user_role.include? "employee" 
        can [:create, :update, :read] , Review if !user_role.include? "manager"
      end
    end
  end
end
