class TaxaController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.csv {send_file "#{Rails.root}/public/data/taxonomic_data/taxonomic_data.csv"}
    end
  end
end
