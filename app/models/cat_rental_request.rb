class CatRentalRequest < ActiveRecord::Base

  STATUS = %w{ PENDING APPROVED DENIED }

  validates :cat_id, :start_date, :end_date, :user_id, presence: true
  validates :status, inclusion: { in: STATUS }
  validate :start_must_come_before_end
  validate :does_not_overlap_approved_request

  belongs_to :cat
  belongs_to :user

  after_initialize do |cat_rental_request|
    self.status ||= "PENDING"
  end

  def approve!
    raise "not pending" unless self.status == "PENDING"
    transaction do
      self.status = "APPROVED"
      self.save!

      # when we approve this request, we reject all other overlapping
      # requests for this cat.
      overlapping_pending_requests.update_all(status: 'DENIED')
    end
  end

  def approved?
    self.status == "APPROVED"
  end

  def denied?
    self.status == "DENIED"
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  private

  def overlapping_requests
    CatRentalRequest
      .where(cat_id: self.cat_id)
      .where.not("? < start_date OR end_date < ?", end_date, start_date)
      .where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end


  def does_not_overlap_approved_request
    return if self.denied?

    unless overlapping_approved_requests.empty?
      errors[:base] <<
        "Request conflicts with existing approved request"
    end
  end

  def start_must_come_before_end
    return if start_date < end_date
    errors[:start_date] << "must come before end date"
    #errors[:end_date] << "must come after start date"
  end

end
