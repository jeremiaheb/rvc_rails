class Sample < ActiveRecord::Base
  extend Pathable
  extend Domainable

  # Get path to sample
  def self.getPath(region, year, filetype)
    super("sample", region, year, filetype)
  end


end
