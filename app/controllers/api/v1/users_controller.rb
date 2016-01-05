module Api
 module V1
  class UsersController < V1Controller

   private

   def resource_params
    params.require(:user).permit(:name, :nationality)
   end

  end
 end
end