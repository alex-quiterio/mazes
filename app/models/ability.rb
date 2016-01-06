class Ability

  include CanCan::Ability

  def initialize(user)
    if (user ||= User.new).admin?
      can :manage, :all
    elsif user.normal?
      can :create, [Book, Author]
      can :update, User, id: user.id
      can [:update, :destroy], [Book, Author], user_id: user.id
    elsif user.guest?
      can :read, :all
    end
  end
end
