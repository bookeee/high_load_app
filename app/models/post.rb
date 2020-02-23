class Post < ApplicationRecord

  belongs_to :user
  has_many :evaluations

  validates_presence_of :title, :content

end