module Api
  module V1
    class SessionsController < ApplicationController

      Swagger::Docs::Generator::set_real_methods

      def create
        user = User.find_by_email(params[:email])
        if user.present? && user.valid_password?(params[:password])
          user.remember_me!(session_ttl)
          render_json_dump({token: user.remember_token, ttl: session_ttl.from_now.to_s})
        else user.present?
          render_json_error('invalid email or password', status: :unprocessable_entity)
        end
      end

      def destroy
        if current_user.present?
          current_user.forget_me!
          head(:ok)
          return
        end
        head(:unprocessable_entity)
      end

      private

      def session_ttl
        2.hours
      end

      # Users Swagger Documentation
      #
      swagger_controller :sessions, "API Sessions"

      swagger_api :create do
        summary "Creates a new API Session with TTL = 2 hours"
        param :form, :email, :string, :required, "User Email"
        param :form, :password, :string, :required, "User Password"
        response :unauthorized
        response :not_acceptable
      end

      swagger_api :destroy do
        summary "Destroy the current API session from that user"
        param :path, :token, :integer, :required, "User Authentication Token"
        response :not_acceptable
      end

    end
  end
end
