class TagPolicy < ApplicationPolicy
    def create?
        user.role != "user"
    end
    def update?
        user.role != "user"
    end
    def destroy?
        user.role != "user"
    end
end