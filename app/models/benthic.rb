class Benthic < ActiveRecord::Base
  extend Pathable
  extend Domainable

  # Override domainable domains, because they
  # aren't available for benthic data yet
  def self.domains
    [{year: 2011, region: "FLA KEYS"}]
  end

  # Get path to benthic data
  def self.getPath(region, year, filetype)
    super("benthic", region, year, filetype)
  end

end
