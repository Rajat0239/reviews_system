class Ability
  include CanCan::Ability
  def initialize(user)
    #byebug
    if user.present?
      userrole = User.find_by(authentication_token: user.authentication_token).roles.pluck:name
      can :manage, :all if userrole[0] == "admin"
    end
  end
end
