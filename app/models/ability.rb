class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = user.roles.pluck:name
      if user_role.include? "admin"
        can :manage, :all 
        cannot [:create], Review
      end
      can [:update], Review if user_role.include? "manager"
      can [:create, :update], Review if user_role.include? "employee"
      # can :manage, :all if user.roles.pluck(:name).include? "admin"
      # can [:read], Role if user_role.include? "manager"
      # can [:read], Role if user_role.include? "employee"
    end
  end
end
