class DataFile
  Error = Class.new(RuntimeError)
  InvalidTypeError = Class.new(Error)
  InvalidRegionError = Class.new(Error)
  InvalidYearError = Class.new(Error)
  InvalidFileTypeError = Class.new(Error)

  REGION_ABBREVIATIONS = {
    "FLA KEYS" => "fk",
    "SEFCRI" => "sefcri",
    "DRY TORT" => "dt",
    "STTSTJ" => "sttstj",
    "STX" => "stx",
    "PRICO" => "prico",
    "FGBNMS" => "fgb"
  }

  FILE_PREFIX_BY_TYPE = {
    "sample" => "",
    "stratum" => "ntot_",
    "benthic" => "benthic_"
  }

  # See data_file_test.rb for examples
  def initialize(type, region, year, file_type, data_path: Rails.configuration.x.data_file_path)
    raise InvalidTypeError, "Invalid type: #{type}" unless FILE_PREFIX_BY_TYPE.key?(type)
    raise InvalidRegionError, "Invalid region: #{region}" unless REGION_ABBREVIATIONS.key?(region)
    raise InvalidYearError, "Invalid year: #{year}" unless /\A[0-9]+\z/ =~ year
    raise InvalidFileTypeError, "Invalid file type: #{file_type}" unless ["csv", "zip"].include?(file_type)

    @type = type
    @region = region
    @year = year.to_i
    @file_type = file_type
    @data_path = data_path
  end

  def path
    File.join(
      @data_path,
      "#{@type}_data", # e.g., sample_data, benthic_data
      "#{FILE_PREFIX_BY_TYPE.fetch(@type)}#{REGION_ABBREVIATIONS.fetch(@region)}#{@year}.#{@file_type}" # e.g., dt2004.zip or ntot_dt2004.zip
    )
  end
end
