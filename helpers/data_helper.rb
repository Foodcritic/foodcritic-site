require "pathname"
require "yaml"

module DataHelper

  def site_data(type)
    YAML.load_file(Pathname.new(__FILE__).dirname.dirname + "#{type}.yml")[type]
  end

end
