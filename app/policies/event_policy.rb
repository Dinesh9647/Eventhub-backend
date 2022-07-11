class EventPolicy < ApplicationPolicy
    def create?
        user.role == "super" or user.role == "admin"
    end
    def update?
        user.role == "super" or user.role == "admin"
    end
    def destroy?
        user.role == "super" or user.role == "admin"
    end
    def register?
        current = DateTime.current()
        current <= record.reg_end and user.role == "user"
    end
    def tags?
        user.role == "super" or user.role == "admin"
    end
    def participants?
        user.role == "super" or user.role == "admin"
    end
end