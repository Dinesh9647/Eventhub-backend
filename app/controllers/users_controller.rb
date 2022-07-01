class UsersController < ApplicationController
    before_action :current_user, except: :create
    wrap_parameters :user, include: [:username, :email, :password, :password_confirmation, :role]

    def create
        @user = User.new(user_params)
        if @user.role != "user"
            return render json: { errors: [ "Access denied" ] }, status: :forbidden
        elsif @user.save
            return render json: {
                user: @user.as_json(except: :password_digest)
            }, status: :created
        else 
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        authorize @user
        render json: { 
            user: @user.as_json(except: :password_digest)
        }, status: :ok
    end

    def update
        @user = User.find(params[:id])
        authorize @user
        if @user.update(update_user_params)
            render json: { 
                user: @user.as_json(except: :password_digest)
            }, status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        authorize @user
        if @user.destroy
            render json: { 
                messages: ["User destroyed"]
            }, status: :ok
        else 
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def register
        if params[:id].to_i != current_user.id
            return render json: { errors: ["Access denied"] }, status: :forbidden
        end
        @user = User.find(params[:id])
        @event = Event.find(params[:event_id])
        authorize @event
        if @user.registrations.create(event: @event)
            render json: { 
                messages: ["Registered Successfully"]
            }, status: :ok
        else
            render json: { errors: ["Registration failed"] }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
    end

    def update_user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
