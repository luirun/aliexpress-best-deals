class User < ApplicationRecord
  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :terms_of_service, acceptance: { accept: "1"}
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates :nickname, presence: true, uniqueness: true, length: { in: 3..20}, on: :create
  validates_presence_of :name, :surname, :password, on: :create

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"},
                             path: ":rails_root/public/system/:attachment/:id/:style/:filename",
                             url: "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def combined_value
    "#{self.name} #{self.surname}"
  end
end
