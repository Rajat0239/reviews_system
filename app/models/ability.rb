class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = User.find_by(authentication_token: user.authentication_token).roles.pluck:name
      can :manage, :all if user_role.include? "admin"
      # can :manage, :all if user.roles.pluck(:name).include? "admin"
      # can [:read], Role if user_role.include? "manager"
      # can [:read], Role if user_role.include? "employee"
    end
  end
end
