class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :update, :destroy, to: :modify

    if user
      user.email == 'admin@mail.com' ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Article, Comment]

    can :modify, [Article, Comment], user_id: user.id
  end
end