$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require
require 'sass/plugin/rack'
require 'app'

run IdeaBoxApp
