module Api
 module V1
  class UsersController < V1Controller

    private

    def resource_params
      if current_user.admin?
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      else
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end

    # Users Swagger Documentation
    #
    swagger_controller :users, "Guttenberg Users"

    swagger_api :show do
      summary "Lists a single User"
      param :path, :id, :integer, :required, "User Id"
      response :not_found
    end

    swagger_api :create do
      summary "Creates a new User"
      param :form, 'user[email]', :string, :required, "User Email"
      param :form, 'user[password]', :string, :required, "User Password"
      param :form, 'user[password_confirmation]', :string, :required, "User Password Confirmation"
      param_list :form, 'user[role]', :string, :required, "User role", User.roles.keys
      response :unauthorized
      response :not_acceptable
    end

    swagger_api :update do
      summary "Updates an existing User"
      param :path, :id, :integer, :required, "User Id"
      param :form, 'user[email]', :string, :required, "Book Title"
      param :form, 'user[password]', :string, :required, "Users Password"
      param :form, 'user[password_confirmation]', :string, :required, "User Password Confirmation"
      param_list :form, 'user[role]', :string, :required, "User role", User.roles.keys
      response :unauthorized
      response :not_found
      response :not_acceptable
    end

    swagger_api :destroy do
      summary "Deletes an existing User"
      param :path, :id, :integer, :required, "User Id"
      response :unauthorized
      response :not_found
    end

  end
 end
end
