class Post < ApplicationRecord

  belongs_to :user
  has_many :evaluations
  has_one :statistics

  validates_presence_of :title, :content

end