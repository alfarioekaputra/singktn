class UsersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
    before_action :set_user, only: %i[ show edit update destroy ]

    def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :username,
          :role_id
        )
    end
      
    def index
        users = User.all

        render inertia: 'Users/Index', props: {
            users: users.as_json(only: [:id, :email, :username, :role_id, :created_at])
        }
    end

    def show
        joined_on = @user.created_at.to_formatted_s(:short)
        sign_in_count = @user.sign_in_count

        if @user.current_sign_in_at
            last_login = @user.current_sign_in_at.to_formatted_s(:short)
        else
            last_login = 'never'
        end

        render inertia: 'Users/Show', props: {
            sign_in_count: sign_in_count.as_json(),
            joined_on: joined_on.as_json(),
            last_login: last_login.as_json()
        }
    end

    def edit
        roles = Role.all

        render inertia: "Users/Edit", props: {
            user: @user.as_json(only: [:id, :username, :email, :password, :role_id]),
            roles: roles.as_json()
        }
    end

    def update
        if user_params[:password].blank?
            user_params.delete(:password)
            user_params.delete(:password_confirmation)
        end
    
        successfully_updated = if needs_password?(@user, user_params)
                                    @user.update(user_params)
                                else
                                    @user.update_without_password(user_params)
                                end
    
        if successfully_updated
            redirect_to @user, notice: 'User was successfully updated.'
        else
            redirect_to edit_user_path(@user), error: @user.errors
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
            @user = User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
            params.require(:user).permit(:id, :username, :email, :password, :role_id)
        end

        def needs_password?(_user, params)
            params[:password].present?
        end
end