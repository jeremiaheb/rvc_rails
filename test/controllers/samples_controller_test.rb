require "test_helper"

class SamplesControllerTest < ActionDispatch::IntegrationTest
  test "renders an HTML index page" do
    get samples_url
    assert_response :success
  end

  test "sends a CSV for a valid region/year combination" do
    get samples_url(region: "FGBNMS", year: "2024", format: "csv")

    assert_equal 200, @response.status
    assert_equal "text/csv", @response.content_type
    assert_equal File.binread(Rails.root.join("test/data/sample_data/fgb2024.csv")), @response.body
    assert_match /s-maxage=0/, @response.headers["Cache-Control"]
  end

  test "sends a ZIP for a valid region/year combination" do
    get samples_url(region: "FGBNMS", year: "2024", format: "zip")

    assert_equal 200, @response.status
    assert_equal "application/zip", @response.content_type
    assert_equal File.binread(Rails.root.join("test/data/sample_data/fgb2024.zip")), @response.body
  end

  test "records analytics" do
    get samples_url(region: "FGBNMS", year: "2024", format: "zip")

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "127.0.0.1",
      data_type: "sample",
      year: 2024,
      format: "zip",
    )
    assert_equal 1, record.count
  end

  test "records analytics behind a proxy" do
    get samples_url(region: "FGBNMS", year: "2024", format: "zip"), headers: {
      "True-Client-IP": "192.0.2.1",
    }

    record = DataFileAnalytics.find_by!(
      date: Date.current,
      ip_address: "192.0.2.1",
      data_type: "sample",
      year: 2024,
      format: "zip",
    )
    assert_equal 1, record.count
  end

  test "sends a 403 Forbidden error if the request is invalid" do
    get samples_url(region: "INVALID", year: "2024", format: "csv")

    assert_equal 403, @response.status
    assert_equal "text/plain; charset=utf-8", @response.content_type
    assert_match /^Invalid region/, @response.body
  end

  test "sends a 404 Not Found error if the file does not exist" do
    get samples_url(region: "FGBNMS", year: "1900", format: "csv")

    assert_equal 404, @response.status
    assert_equal "text/plain; charset=utf-8", @response.content_type
  end
end
