module Pathable

  def getPath(model, region, year, filetype)
    abr = case region
      when "FLA KEYS" then "fk"
      when "SEFCRI" then "sefcri"
      when "DRTO" then "dt"
      else raise "unknown region"
    end

    path = if model == "sample"
      "#{Rails.root}/public/data/sample_data/#{abr}#{year}.#{filetype}"
    elsif model == "stratum"
      "#{Rails.root}/public/data/stratum_data/ntot_#{abr}#{year}.#{filetype}"
    else
      raise "model unrecognized"
    end

    return path
  end

end
