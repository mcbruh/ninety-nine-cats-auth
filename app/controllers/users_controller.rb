class UsersController < ApplicationController

    before_action :require_current_user!, except: [:create, :new]

    def create
        @user = User.new(user_params)

        if @user.save
            login!(@user)
            redirect_to cats_url
        else
            render json: @user.errors.full_messages
        end
    end

    def new
        @user = User.new
        render :new
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end

end
