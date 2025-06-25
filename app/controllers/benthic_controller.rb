class BenthicController < ApplicationController
  def index
    @domains = [
      {year: 2011, region: "FLA KEYS"}
    ]

    respond_to do |format|
      format.html
      format.csv { send_data_file }
    end
  end
end
