require "test_helper"

class TaxaControllerTest < ActionDispatch::IntegrationTest
  test "renders an HTML index page" do
    get taxa_url
    assert_response :success
  end

  test "sends a CSV with the singular taxonomic data file" do
    get taxa_url(format: "csv")

    assert_equal 200, @response.status
    assert_equal "text/csv", @response.content_type
    assert_equal File.binread(Rails.root.join("test/data/taxonomic_data/taxonomic_data.csv")), @response.body
  end

  test "sends a 406 Not Acceptable error if a ZIP file is requested" do
    get taxa_url(format: "zip")

    assert_equal 406, @response.status
  end
end
