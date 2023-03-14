module Pathable

  def getPath(model, region, year, filetype)
    abr = case region
      when "FLA KEYS" then "fk"
      when "SEFCRI" then "sefcri"
      when "DRY TORT" then "dt"
      when "STTSTJ" then "sttstj"
      when "STX" then "stx"
      when "PRICO" then "prico"
      when "FGBNMS" then "fgb"
      else raise "unknown region"
    end

    path = if model == "sample"
      "#{Rails.root}/public/data/sample_data/#{abr}#{year}.#{filetype}"
    elsif model == "stratum"
      "#{Rails.root}/public/data/stratum_data/ntot_#{abr}#{year}.#{filetype}"
    elsif model == "benthic"
      "#{Rails.root}/public/data/benthic_data/benthic_#{abr}#{year}.#{filetype}"
    else
      raise "model unrecognized"
    end

    return path
  end

end
