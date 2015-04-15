class Cat < ActiveRecord::Base

  COLORS = [
    "black",
    "brown",
    "calico"
  ]

  SEX = [
    "M",
    "F"
  ]

  has_many :cat_rental_requests, dependent: :destroy

  validates :color, presence: true, inclusion: COLORS
  validates :sex, presence: true, inclusion: SEX
  validates :birth_date, :name, presence: true

  def age
    ((Time.now - birth_date) / (365*24*60*60)).round(2)
  end
  
end
