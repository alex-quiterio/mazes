class Book < ActiveRecord::Base
 validates :title, :author, presence: true
 enum genre: [:undefined, :crime, :romance, :horror, :fantasy, :mystery, :western]
 belongs_to :author
 belongs_to :user
end
