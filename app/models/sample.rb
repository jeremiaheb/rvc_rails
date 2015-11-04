class Sample < ActiveRecord::Base

  # Validations
  PATH_REGEX = /\A\S+\.csv\Z/i
  validates :year, presence: true,
    numericality: {only_integer: true, greater_than: 1998}
  validates :region, presence: true,
    uniqueness: {scope: [:year]},
    inclusion: {in: ["FLA KEYS", "DRTO", "SEFCRI"],
      message: 'is not a valid region'}
  validates :sample_path, presence: true,
    format: {with: PATH_REGEX, message: "is not a valid sample path"}
  validates :stratum_path, presence: true,
    format: {with: PATH_REGEX, message: "is not a valid stratum_path"}
end
