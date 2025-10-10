require "application_system_test_case"

class SamplesTest < ApplicationSystemTestCase
  test "downloading sample data via website" do
    original_file_path = File.join(Rails.configuration.x.data_file_path, "sample_data", "fgb2024.csv")
    expected_download_path = File.join(DEFAULT_DOWNLOAD_DIRECTORY, "fgb2024.csv")

    visit root_url
    find(".sample-data-link").click

    refute File.exist?(expected_download_path), "download already exists"

    find("#region-select").select("FGBNMS")
    find("#year-select").select("2024")
    find("#format-select").select("csv")
    find("#download-button").click

    wait_until do
      File.exist?(expected_download_path)
    end

    assert_equal File.read(original_file_path), File.read(expected_download_path), "file contents are incorrect"
  end
end
