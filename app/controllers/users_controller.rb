class UsersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, :with => :username_not_found
    def create
        if user_params[:password] == user_params[:password_confirmation]
        user = User.create(user_params)
            if user.valid? 
            session[:user_id] = user.id
            render json: user, status: :created
            else
            render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {error: "youre passwords are different"}, status: 422
        end

    end

    def show
        if  session[:user_id]
             user = User.find(session[:user_id])
             render json: user
        else
            render json: { error: "you are not authorized" }, status: :unauthorized
        end
    end


    private
    def user_params
        params.permit :username, :password, :password_confirmation
    end

    def username_not_found e
        render json: { errors: "record not found" }, status: :not_found
    end
end
