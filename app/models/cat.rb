class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :gender, presence: true
  validates :color, inclusion: { in: %w(white orange black calico brown) }
  validates :gender, inclusion: { in: %w(M F) }

  def age
    ((Date.today - birth_date)/365).to_i
  end
end
