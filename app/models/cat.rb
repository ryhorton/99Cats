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
  belongs_to(
    :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  validates :color, presence: true, inclusion: { in: COLORS }
  validates :sex, presence: true, inclusion: { in: SEX }
  validates :birth_date, :name, presence: true
  validates :user_id, presence: true

  def age
    ((Time.now - birth_date) / (365*24*60*60)).round(2)
  end

end
