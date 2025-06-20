class DataFileAnalytics < ApplicationRecord
  validates :date, presence: true
  validates :ip_address, presence: true
  validates :data_type, presence: true
  validates :year, presence: { allow_blank: true }
  validates :region, presence: { allow_blank: true }
  validates :format, presence: true

  def self.increment_count(date:, ip_address:, data_type:, year:, region:, format:)
    tries ||= 0
    record = find_or_create_by!(
      date: date,
      ip_address: ip_address,
      data_type: data_type.strip.downcase,
      year: year,
      region: region.strip.upcase,
      format: format.strip.downcase,
    )

    # Atomic increment
    update_counters(record.id, count: +1)
  rescue ActiveRecord::RecordNotUnique => e
    # On retry, the existing record should be found
    retry if (tries += 1) == 1
    raise # otherwise
  end
end
