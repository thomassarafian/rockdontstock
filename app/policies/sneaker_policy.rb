class SneakerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
		scope.all
		#scope.where(user: user) -> a utiliser pour la page "Mon compte"
    end
  end
  
  def create? # Anyone can create a sneaker
  	true
  end
  
  def show? # Anyone can view a sneaker
  	true
  end
  
  def update?
  	record.user == user # Only sneaker creator can update it
  end
  def destroy?
  	record.user == user # Only sneaker creator can delete it
  end
end
