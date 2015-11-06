class Sample < ActiveRecord::Base
  extend Pathable

  def self.getPath(region, year, filetype)
    super("sample", region, year, filetype)
  end

end
