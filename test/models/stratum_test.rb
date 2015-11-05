require 'test_helper'

class StratumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "getPath returns correct path" do
    assert_equal Stratum.getPath("FLA KEYS", 2012, "csv"), "#{Rails.root}/public/data/"\
    "stratum_data/ntot_fk2012.csv"
  end
end
