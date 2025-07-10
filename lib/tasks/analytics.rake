require 'csv'

# Just checking
namespace :analytics do
  desc "Downloads all DataFileAnalytics records into a CSV file"
  task download_csv: :environment do
    # Define the path for your CSV file
    file_path = Rails.root.join('tmp', 'data_file_analytics.csv')

    # The headers for your CSV file
    headers = ['Date', 'IP Address', 'Data Type', 'Year', 'Region', 'Format', 'Count']

    # Use the CSV library to create the file
    CSV.open(file_path, 'w', write_headers: true, headers: headers) do |csv|
      # Fetch all of the DataFileAnalytics records
      DataFileAnalytics.find_each do |record|
        # Add a row to the CSV for each record
        csv << [
          record.date,
          record.ip_address,
          record.data_type,
          record.year,
          record.region,
          record.format,
          record.count # Assuming you have a 'count' attribute
        ]
      end
    end

    puts "Successfully downloaded analytics to #{file_path}"
  end
end