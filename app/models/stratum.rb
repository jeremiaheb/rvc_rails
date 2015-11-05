class Stratum < ActiveRecord::Base
  def self.getPath(region, year, filetype)
    ## TODO Move to helper module
    abr = case region
      when "FLA KEYS" then "fk"
      when "SEFCRI" then "sefcri"
      when "DRTO" then "dt"
      else raise "unknown region"
    end
    return "#{Rails.root}/public/data/sample_data/ntot_#{abr}#{year}.#{filetype}"
  end
end
