class ApplicationController < ActionController::Base
    include Pundit, Error::ErrorHandler
    protect_from_forgery unless: -> { request.format.json? }
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def current_user
        header = request.headers['Authorization']
        if !header
            return render json: { errors: ["Token not found"] }, status: :unauthorized
        end
        header = header.split(' ').last if header
        begin
            @decoded = JsonWebToken.decode(header)
            if !@decoded
                return render json: { errors: ["Invalid token"] }, status: :unauthorized
            end
            @current_user = User.find(@decoded[:user_id]);
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def user_not_authorized(_exception)
        render json: { errors: [ "Access denied" ] }, status: :forbidden
    end
end
