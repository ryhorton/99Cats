class CatRentalRequest < ActiveRecord::Base

  STATUS = %w{ PENDING APPROVED DENIED }

  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: STATUS
  validate :no_overlapping_approval_requests

  belongs_to :cat

  after_initialize do |cat_rental_request|
    self.status ||= "PENDING"
  end

  def overlapping_requests
    CatRentalRequest
      .where(cat_id: self.cat_id)
      .where.not("? < start_date OR end_date < ?", end_date, start_date)
      .where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def no_overlapping_approval_requests
    fail
    if !overlapping_approved_requests.empty?
      errors[:cat_id] << "Can't overbook cat"
    end
  end
end
