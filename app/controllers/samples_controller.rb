class SamplesController < ApplicationController
  def index
    @year = query_params[:year]
    @region = query_params[:region]
    respond_to do |format|
      format.html
      format.csv {
        if @year && @region
          send_file Sample.getPath(@region.to_s, @year.to_i, 'csv')
        else
          render nothing: true, status: 404
        end
      }
      format.zip {
        if @year && @region
          send_file Sample.getPath(@region.to_s, @year.to_i, 'zip')
        else
          render nothing: true, status: 404
        end
      }
    end
  end

  private
    def query_params
      params.permit(:year, :region)
    end
end
