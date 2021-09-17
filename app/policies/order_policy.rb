class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  def new? # Anyone can create a order
    true
  end
  def create? # Anyone can create a order
  	true
  end
  def show? # Anyone can create a order
  	true
  end
end
