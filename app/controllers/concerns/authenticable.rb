module Authenticable
 def current_user
  @current_user ||= {}
  @current_user[remember_token] ||= begin
   user = User.find_by_remember_token(remember_token)
   user unless !!user.try(:remember_expired?)
  end
 end

 def authenticate!
  raise Api::NotLoggedIn.new if current_user.blank?
 end

 def remember_token
  params[:token] || request.headers['Authorization']
 end

end
