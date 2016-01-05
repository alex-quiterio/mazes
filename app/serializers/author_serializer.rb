class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :nationality, :user_id, :book_ids

  def initialize(object, options = {})
   super(object, options.merge(root: false))
  end
end
