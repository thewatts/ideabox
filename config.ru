$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require
require 'sass/plugin/rack'
require 'app'

# use scss for stylesheets
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run IdeaBoxApp
