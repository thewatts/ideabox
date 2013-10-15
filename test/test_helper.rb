ENV["RACK_ENV"] = "test"

require 'bundler'
Bundler.require

require './lib/app'

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

Dir[File.join("test", "support", "**", "*.rb")].each do |file|
  require File.expand_path(file)
end

def app

end
