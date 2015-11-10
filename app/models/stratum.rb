class Stratum < ActiveRecord::Base
  extend Pathable
  extend Domainable

  def self.getPath(region, year, filetype)
    super("stratum", region, year, filetype)
  end

end
