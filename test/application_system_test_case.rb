require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DEFAULT_DOWNLOAD_DIRECTORY = Rails.root.join("tmp", "downloads")

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
    options.add_preference("download.default_directory", DEFAULT_DOWNLOAD_DIRECTORY.to_s)
    options.add_preference("download.prompt_for_download", false)
    options.add_option("goog:loggingPrefs", { browser: "ALL" })
  end

  setup do
    FileUtils.rm_rf(DEFAULT_DOWNLOAD_DIRECTORY)
    FileUtils.mkdir_p(DEFAULT_DOWNLOAD_DIRECTORY)
  end

  def wait_until(time = Capybara.default_max_wait_time)
    Timeout.timeout(time) do
      until value = yield
        sleep(0.1)
      end

      value
    end
  end
end
