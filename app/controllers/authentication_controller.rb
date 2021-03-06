class AuthenticationController < ApplicationController
    before_action :authorize_request, except: [:login, :adminlogin]

    # POST /auth/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            render json: { token: token, 
                user: @user.as_json(except: :password_digest ) 
            }, status: :ok
        else
            render json: { errors: ['Invalid email/password'] }, status: :unauthorized
        end
    end

    def adminlogin
        @user = User.find_by_email(params[:email])
        if @user.role == 'user'
            return render json: { errors: ["Access Denied"] }, status: :forbidden
        end
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            render json: { token: token, 
                user: @user.as_json(except: :password_digest ) 
            }, status: :ok
        else
            render json: { errors: ['Invalid email/password'] }, status: :unauthorized
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end
