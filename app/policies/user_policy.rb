class UserPolicy < ApplicationPolicy
    # User level
    def show?
        record.role == "user" and (user.role == "super" or record == user or user.role == "admin")
    end
    def update?
        record.role == "user" and (user.role == "super" or record == user or user.role == "admin")
    end
    def destroy?
        record.role == "user" and (user.role == "super" or record == user or user.role == "admin")
    end

    # Admin level
    def can_create?
        user.role == "super" and record.role == "admin"
    end
    def can_show?
        user.role == "super" or (user.role == "admin" and record == user)
    end
    def can_update?
        user.role == "super" or (user.role == "admin" and user == record)
    end
    def can_destroy?
        user.role == "super" or (user.role == "admin" and record == user)
    end
end

