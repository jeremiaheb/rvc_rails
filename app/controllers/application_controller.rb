class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def invalid_format
    raise ActionController::RoutingError.new('Invalid Format or Parameters')
  end

  def file_not_found
    raise ActionController::RoutingError.new('File Not Found')
  end

  ## If unknown format or file requested, respond with 404
  rescue_from ActionController::UnknownFormat, :with => :invalid_format
  rescue_from ActionController::MissingFile, :with => :file_not_found

  def index(model)
    @domains = model.domains
    @year = query_params[:year]
    @region = query_params[:region]
    has_params = @year && @region
    respond_to do |format|
      format.html
      format.csv {
        send_file model.getPath(@region.to_s, @year.to_i, 'csv')
      } if has_params
      format.zip {
        send_file model.getPath(@region.to_s, @year.to_i, 'zip')
      } if has_params && model == Sample
    end
  end

  private
    def query_params
      params.permit(:year, :region)
    end

end
