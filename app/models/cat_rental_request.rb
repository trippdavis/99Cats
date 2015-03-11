class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :overlapping_approved_requests

  after_initialize do |rental_request|
    rental_request.status ||= 'PENDING'
  end

  belongs_to(
    :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id
  )

  def overlapping_approved_requests
    if (overlapping_requests.any?{ |request| request.status == 'APPROVED' }) && status == "APPROVED"
      errors.add(:status, "can't conflict with another approved rental")
    end
  end

  def overlapping_requests
    id = @id.nil? ? 0 : @id

    CatRentalRequest.find_by_sql ([<<-SQL, end_date, start_date, id])
      SELECT
        *
      FROM
        cat_rental_requests
      WHERE
        cat_id = #{cat_id} AND NOT (start_date > ? OR end_date < ?) AND id != ?
    SQL
  end
end
