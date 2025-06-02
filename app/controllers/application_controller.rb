class ApplicationController < ActionController::Base
  protected

  # Send a data file to the client using parameters in the request
  def send_data_file(type: params[:controller].singularize, region: params[:region], year: params[:year], format: params[:format])
    data_file = DataFile.new(type, region, year, format)
    send_file data_file.path
  rescue DataFile::Error => e
    render plain: e.message, status: :forbidden, content_type: "text/plain"
  rescue ActionController::MissingFile, ActionController::UnknownFormat => e
    render plain: "File not found", status: :not_found, content_type: "text/plain"
  end
end
