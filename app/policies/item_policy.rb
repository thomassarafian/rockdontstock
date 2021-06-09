class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
   def index?
    true
    # record.user == user 
  end
end
