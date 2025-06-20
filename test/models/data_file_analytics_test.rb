require "test_helper"

class DataFileAnalyticsTest < ActiveSupport::TestCase
  test "tracks data file downloads by date/ip/type/year/region/format dimensions" do
    DataFileAnalytics.increment_count(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "stratum",
      year: 2024,
      region: "DRY TORT",
      format: "csv",
    )

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "stratum",
      year: 2024,
      region: "DRY TORT",
      format: "csv",
    )
    assert_equal 1, record.count
  end

  test "increments the counter for the same date/ip/type/year/region/format dimensions" do
    3.times do
      DataFileAnalytics.increment_count(
        date: Date.current,
        ip_address: "192.0.2.1",
        data_type: "stratum",
        year: 2024,
        region: "DRY TORT",
        format: "csv",
      )
    end

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "stratum",
      year: 2024,
      region: "DRY TORT",
      format: "csv",
    )
    assert_equal 3, record.count
  end

  test "normalizes strings of different case" do
    rv = DataFileAnalytics.increment_count(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "sTrAtUm",
      year: 2024,
      region: "Dry Tort",
      format: "CSV",
    )

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "stratum", # downcased
      year: 2024,
      region: "DRY TORT", # upcased
      format: "csv", # downcased
    )
    assert_equal 1, record.count
  end

  test "handles a possible race condition if another thread creates the record first" do
    calls = 0
    DataFileAnalytics.stub :find_or_create_by!, ->(*args, **kwargs, &blk) {
      raise ActiveRecord::RecordNotUnique if (calls += 1) == 1
      DataFileAnalytics.find_or_create_by(*args, **kwargs, &blk)
    } do
      3.times do
        DataFileAnalytics.increment_count(
          date: Date.current,
          ip_address: "192.0.2.1",
          data_type: "stratum",
          year: 2024,
          region: "DRY TORT",
          format: "csv",
        )
      end
    end

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "stratum",
      year: 2024,
      region: "DRY TORT",
      format: "csv",
    )
    assert_equal 3, record.count
  end
end
