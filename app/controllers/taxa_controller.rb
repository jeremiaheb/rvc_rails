class TaxaController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.csv { send_file File.join(Rails.configuration.x.data_file_path, "taxonomic_data", "taxonomic_data.csv") }
    end
  end
end
