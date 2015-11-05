class StrataController < ApplicationController
  # TODO refactor to reduce duplication with samples
  def index
    @year = query_params[:year]
    @region = query_params[:region]
    respond_to do |format|
      format.html
      format.csv {
        if @year && @region
          send_file Stratum.getPath(@region.to_s, @year.to_i, 'csv')
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
