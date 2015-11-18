class Benthic < ActiveRecord::Base
  extend Pathable
  extend Domainable

  # Get path to benthic data
  def self.getPath(region, year, filetype)
    super("benthic", region, year, filetype)
  end
end
