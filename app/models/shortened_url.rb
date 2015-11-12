

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :presence => true
  validates :short_url, :uniqueness => true
  validates :long_url, :presence => true
  validates :long_url, :uniqueness => true
  validates :submitter_id, :presence => true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
  -> { distinct },
  through: :visits,
  source: :visitors


  def self.random_code
    code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: :code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(submitter_id: user.id, long_url: long_url, short_url: self.random_code)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    # .where(created_at: Time.now)
    self.visits.select(:user_id).distinct.where("created_at > :time", time: 10.minutes.ago).count
  end
end
