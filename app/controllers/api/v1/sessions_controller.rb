module Api
  module V1
    class SessionsController < ApplicationController

      skip_before_action :verify_authenticity_token

      def create
        user = User.find_by_email(params[:email])
        if user.present? && user.valid_password?(params[:password])
          user.remember_me!(2.hours)
          render_serialized(user, UserSerializer)
          return
        elsif user.present?
          render_serialized(user, UserSerializer)
          return
        end
        head(:unprocessable_entity)
      end

      def destroy
        if current_user.present?
          user.forget_me!
          head(:ok)
          return
        end
        head(:unprocessable_entity)
      end

    end
  end
end
