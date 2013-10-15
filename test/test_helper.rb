ENV["RACK_ENV"] = "test"

require 'minitest'
require 'minitest/autorun'
#require 'minitest/spec'
require 'minitest/pride'

Dir[File.join("test", "support", "**", "*.rb")].each do |file|
  require File.expand_path(file)
end
