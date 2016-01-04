class User < ActiveRecord::Base
 has_many :books, dependent: :destroy
 has_many :authors, dependent: :destroy
 enum role: { guest: 0, normal: 1, admin: 2 }
 # Include default devise modules. Others available are:
 # :confirmable, :lockable, :timeoutable and :omniauthable
 devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
end
