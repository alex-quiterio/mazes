class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role

  def initialize(object, options = {})
   super(object, options.merge(root: false))
  end

  def current_token
   object.remember_token
  end
end
