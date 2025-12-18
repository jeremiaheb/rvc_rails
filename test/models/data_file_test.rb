require "test_helper"

class DataFileTest < ActiveSupport::TestCase
  test "#path returns the full path to the file" do
    assert_equal "sample_data/dt2004.csv", DataFile.new("sample", "DRY TORT", "2004", "csv").path
    assert_equal "sample_data/fk2025.zip", DataFile.new("sample", "FLA KEYS", "2025", "zip").path

    # stratum files are prefixed with ntot_
    assert_equal "stratum_data/ntot_dt2004.csv", DataFile.new("stratum", "DRY TORT", "2004", "csv").path
    assert_equal "stratum_data/ntot_fk2025.zip", DataFile.new("stratum", "FLA KEYS", "2025", "zip").path

    # benthic files are prefixed with benthic_
    assert_equal "benthic_data/benthic_dt2004.csv", DataFile.new("benthic", "DRY TORT", "2004", "csv").path
    assert_equal "benthic_data/benthic_fk2025.zip", DataFile.new("benthic", "FLA KEYS", "2025", "zip").path
  end

  test "accepts only valid data types" do
    assert_nothing_raised do
      ["sample", "stratum", "benthic"].each do |valid_type|
        DataFile.new(valid_type, "DRY TORT", "2004", "csv")
      end
    end

    assert_raises DataFile::InvalidTypeError do
      DataFile.new("invalid", "DRY TORT", "2004", "csv")
    end
  end

  test "accepts only valid regions" do
    assert_nothing_raised do
      ["FLA KEYS", "SEFCRI", "PRICO"].each do |valid_region|
        DataFile.new("sample", valid_region, "2004", "csv")
      end
    end

    assert_raises DataFile::InvalidRegionError do
      DataFile.new("sample", "invalid", "2004", "csv")
    end
  end

  test "accepts only valid years" do
    assert_nothing_raised do
      ["1999", "2000", "2025"].each do |valid_year|
        DataFile.new("sample", "DRY TORT", valid_year, "csv")
      end
    end

    assert_raises DataFile::InvalidYearError do
      DataFile.new("sample", "DRY TORT", "abc123", "csv")
    end

    assert_raises DataFile::InvalidYearError do
      DataFile.new("sample", "DRY TORT", "2005/..", "csv")
    end

    assert_raises DataFile::InvalidYearError do
      DataFile.new("sample", "DRY TORT", nil, "csv")
    end
  end

  test "accepts only valid file types" do
    assert_nothing_raised do
      ["csv", "zip"].each do |valid_file_type|
        DataFile.new("sample", "DRY TORT", "2004", valid_file_type)
      end
    end

    assert_raises DataFile::InvalidFileTypeError do
      DataFile.new("sample", "DRY TORT", "2004", "txt")
    end

    assert_raises DataFile::InvalidFileTypeError do
      DataFile.new("sample", "DRY TORT", "2004", ".csv")
    end
  end
end
