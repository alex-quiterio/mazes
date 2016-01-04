class Author < ActiveRecord::Base
 validates :name, :nationality, presence: true
 validates :name, uniqueness: true

 has_many :books
 belongs_to :user
end
