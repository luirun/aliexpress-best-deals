class User < ApplicationRecord
  has_many :reviews
  has_many :productLike
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validates :terms_of_service, acceptance: { accept: '1' }
  validates :nickname, presence: true, uniqueness: true, length: { in: 3..20 }, on: :create
  validates :name, :surname, :password, presence: { on: :create }

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             path:   ':rails_root/public/system/:attachment/:id/:style/:filename',
                             url:    '/system/:attachment/:id/:style/:filename'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def combined_value
    "#{name} #{surname}"
  end
end
