class Ability
  include CanCan::Ability
  def initialize(user)
    if user.present?
      user_role = User.find_by(authentication_token: user.authentication_token).roles.pluck:name
      can :manage, :all if user_role.include? "admin"
    end
  end
end
