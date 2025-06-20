class TaxaController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.csv { send_data_file }
    end
  end
end
