class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      @user.admin? ? admin_abilities : user_abilities
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

    can :mark_the_best, Answer do |answer|
      answer.question.user_id == @user.id
    end

    can :create, [Question, Answer, Comment, Subscription]
    can [:edit, :destroy, :update], [Answer, Question], user_id: @user.id

    can [:create],  Vote do |vote|
      vote.votable.user_id != @user.id
    end

    can :destroy, Vote, user_id: @user.id
    can :destroy, Subscription, user_id: @user.id
  end
end
