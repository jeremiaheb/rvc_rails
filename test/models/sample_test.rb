require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # Use Shoulda gem to test model validations
  # Presence Validators
  should validate_presence_of(:year)
  should validate_presence_of(:region)
  should validate_presence_of(:sample_path)
  should validate_presence_of(:stratum_path)
  # Numericality of year
  should validate_numericality_of(:year).only_integer.is_greater_than(1998)
  # Inclusion validators for region
  should validate_inclusion_of(:region).in_array(["FLA KEYS", "DRTO", "SEFCRI"])
  # Path regex validators
  should allow_value('public/data/sample_data/fk2012.csv')
    .for(:sample_path).with_message('is not a valid sample path')
  should allow_value('public/data/stratum_data/fk2012.csv')
    .for(:stratum_path).with_message('is not a valid stratum path')
  should_not allow_value('oops')
    .for(:sample_path)
  should_not allow_value('foo')
    .for(:stratum_path)
  # Year/Region uniqueness validator
  should validate_uniqueness_of(:region).scoped_to(:year)
end
