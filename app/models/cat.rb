class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :gender, presence: true
  validates :color, inclusion: { in: %w(white orange black calico brown) }
  validates :gender, inclusion: { in: %w(M F) }

  has_many(
    :rental_requests,
    class_name: 'CatRentalRequest',
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )

  def age
    ((Date.today - birth_date)/365).to_i
  end

  def sorted_requests
    rental_requests.sort_by { |request| request.start_date }
  end
end
