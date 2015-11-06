class Stratum < ActiveRecord::Base
  extend Pathable

  def self.getPath(region, year, filetype)
    super("stratum", region, year, filetype)
  end
  
end
