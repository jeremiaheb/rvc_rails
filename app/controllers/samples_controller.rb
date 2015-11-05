class SamplesController < ApplicationController
  def index
    @sample = Sample.where(query_params).first
    respond_to do |format|
      format.html
      format.csv {
        send_file "#{Rails.root}/#{@sample.sample_path}"
      }
      format.zip {
        send_file "#{Rails.root}/#{@sample.sample_zip}"
      }
    end
  end

  private
    def query_params
      params.permit(:year, :region)
    end
end
