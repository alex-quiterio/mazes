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

  end
 end
end
