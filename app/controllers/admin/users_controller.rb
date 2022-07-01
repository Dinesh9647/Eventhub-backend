class Admin::UsersController < ApplicationController
    before_action :current_user
    wrap_parameters :user, include: [:username, :email, :password, :password_confirmation, :role]

    def create
        @user = User.new(admin_params)
        authorize @user, :can_create?
        if @user.save
            return render json: {
                user: @user.as_json(except: :password_digest)
            }, status: :created
        else 
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        authorize @user, :can_show?
        render json: { 
            user: @user.as_json(except: :password_digest)
        }, status: :ok
    end

    def update
        @user = User.find(params[:id])
        authorize @user, :can_update?
        if @user.update(update_admin_params)
            render json: { 
                user: @user.as_json(except: :password_digest)
            }, status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        authorize @user, :can_destroy?
        if @user.destroy
            render json: { 
                messages: ["User destroyed"]
            }, status: :ok
        else 
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def admin_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
    end

    def update_admin_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
