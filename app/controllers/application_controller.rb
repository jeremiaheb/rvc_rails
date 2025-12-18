class ApplicationController < ActionController::Base
  protected

  # Send a data file to the client using parameters in the request
  def send_data_file(type: params[:controller].singularize, region: params[:region], year: params[:year], format: params[:format])
    # Allow caching but require revalidation from public caches
    #
    # See:
    # - https://github.com/rails/rails/blob/2994a6cd4a4c0bc017ec39d23a58be7fc52c9f79/actionpack/lib/action_dispatch/http/cache.rb#L340-L354
    # - https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control
    response.cache_control.replace(
      no_cache: false,
      no_store: false,
      # Maximum length of time for private (e.g., browser) caches
      max_age: 1.hour,
      # Maximum length of time for public (e.g., CDN) caches
      public: true,
      extras: ["s-maxage=0", "must-revalidate", "proxy-revalidate"],
      stale_while_revalidate: 7.days,
      stale_if_error: 7.days,
    )

    case type
    when "taxa"
      send_file_from_cloud_or_disk(File.join("taxonomic_data", "taxonomic_data.csv"))
    else
      data_file = DataFile.new(type, region, year, format)
      send_file_from_cloud_or_disk(data_file.path)
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

  # send_file_from_cloud_or_disk sends a data file from Google Cloud (if running
  # on Google Cloud) or from disk otherwise
  def send_file_from_cloud_or_disk(path)
    stream = \
      if running_on_google_cloud?
        bucket = Google::Cloud::Storage.new(project_id: "ggn-nmfs-sencrmp-prod-1").bucket("ncrmp-bucket-storage")
        file = bucket.file(File.join("rvc", "public", "data", path))
        raise ActionController::MissingFile if file.nil?

        file.download
      else
        File.open(File.join(Rails.configuration.x.data_file_path, path), "rb")
      end

    set_file_response_headers(path)
    self.response_body = stream
  rescue Errno::ENOENT
    raise ActionController::MissingFile
  end

  def set_file_response_headers(path)
    filename = File.basename(path)

    self.content_type = Mime::Type.lookup_by_extension(File.extname(filename).downcase.delete("."))
    response.sending_file = true
    response.headers["Content-Disposition"] = ActionDispatch::Http::ContentDisposition.format(disposition: "attachment", filename: filename)
    response.headers["Content-Transfer-Encoding"] = "binary"
  end

  # Returns true if running on Google Cloud
  def running_on_google_cloud?
    File.exist?("/etc/google_instance_id") || ENV.fetch("FORCE_GOOGLE_CLOUD", false)
  end
end
