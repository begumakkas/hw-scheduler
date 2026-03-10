class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many  :tasks, class_name: "Task", foreign_key: "user_id", dependent: :destroy
  has_many  :courses, class_name: "Course", foreign_key: "user_id", dependent: :destroy
  has_many  :syllabis, class_name: "Syllabi", foreign_key: "user_id", dependent: :destroy
end
