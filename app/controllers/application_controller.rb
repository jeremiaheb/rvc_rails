class ApplicationController < ActionController::Base
  protected

  # Send a data file to the client using parameters in the request
  def send_data_file(type: params[:controller].singularize, region: params[:region], year: params[:year], format: params[:format])
    case type
    when "taxa"
      send_file File.join(Rails.configuration.x.data_file_path, "taxonomic_data", "taxonomic_data.csv")
    else
      data_file = DataFile.new(type, region, year, format)
      send_file data_file.path
    end

    # Record analytics
    DataFileAnalytics.increment_count(
      date: Date.current,
      ip_address: request.headers["True-Client-IP"].presence || request.remote_ip,
      data_type: type,
      region: region.to_s,
      year: year.to_i,
      format: format.to_s,
    )
  rescue DataFile::Error => e
    render plain: e.message, status: :forbidden, content_type: "text/plain"
  rescue ActionController::MissingFile, ActionController::UnknownFormat => e
    render plain: "File not found", status: :not_found, content_type: "text/plain"
  end
end
