require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "getPath returns correct path" do
    assert_equal Sample.getPath("FLA KEYS", 2012, "csv"), "#{Rails.root}/public/data/"\
    "sample_data/fk2012.csv"
  end
end
