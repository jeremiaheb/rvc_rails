require "test_helper"

class BenthicControllerTest < ActionDispatch::IntegrationTest
  test "renders an HTML index page" do
    get benthic_url
    assert_response :success
  end

  test "sends a CSV for a valid region/year combination" do
    get benthic_url(region: "FLA KEYS", year: "2011", format: "csv")

    assert_equal 200, @response.status
    assert_equal "text/csv", @response.content_type
    assert_equal File.read(Rails.root.join("test/data/benthic_data/benthic_fk2011.csv")), @response.body
  end

  test "sends a 406 Not Acceptable error if a ZIP file is requested" do
    get benthic_url(region: "FLA KEYS", year: "2011", format: "zip")

    assert_equal 406, @response.status
  end

  test "sends a 403 Forbidden error if the request is invalid" do
    get benthic_url(region: "INVALID", year: "2011", format: "csv")

    assert_equal 403, @response.status
    assert_equal "text/plain; charset=utf-8", @response.content_type
    assert_match /^Invalid region/, @response.body
  end

  test "sends a 404 Not Found error if the file does not exist" do
    get benthic_url(region: "FLA KEYS", year: "1900", format: "csv")

    assert_equal 404, @response.status
    assert_equal "text/plain; charset=utf-8", @response.content_type
  end
end
