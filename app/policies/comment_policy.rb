class CommentPolicy < ApplicationPolicy
  def create?
    user
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
