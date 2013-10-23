$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require
require 'sass/plugin/rack'
require 'app'
require 'api'

run IdeaBoxApp

map '/api/v1' do
  run IdeaBoxAPI
end
