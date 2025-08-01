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
    "FGBNMS" => "fgb",
  }

  FOLDER_NAME_BY_TYPE = {
    "sample" => "sample_data",
    "stratum" => "stratum_data",
    "benthic" => "benthic_data",
  }

  FILE_PREFIX_BY_TYPE = {
    "stratum" => "ntot_",
    "benthic" => "benthic_",
  }

  # See data_file_test.rb for examples
  def initialize(type, region, year, file_type, data_path: Rails.configuration.x.data_file_path)
    raise InvalidTypeError, "Invalid type: #{type}" unless FOLDER_NAME_BY_TYPE.key?(type)
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
      FOLDER_NAME_BY_TYPE.fetch(@type),
      "#{FILE_PREFIX_BY_TYPE.fetch(@type, "")}#{REGION_ABBREVIATIONS.fetch(@region)}#{@year}.#{@file_type}" # e.g., dt2004.zip or ntot_dt2004.zip
    )
  end
end
