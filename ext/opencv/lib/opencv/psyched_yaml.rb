# -*- mode: ruby; coding: utf-8-unix -*- 
# Psych loader for avoiding loading problem
# (borrowed from Bundler 1.1.rc.7 https://github.com/carlhuda/bundler/blob/v1.1.rc.7/lib/bundler/psyched_yaml.rb )
#
# See: https://github.com/ruby-opencv/ruby-opencv/pull/6

# Psych could be a gem
begin
  gem 'psych'
rescue Gem::LoadError
end if defined?(Gem)

# Psych could be a stdlib
begin
  # it's too late if Syck is already loaded
  require 'psych' unless defined?(Syck)
rescue LoadError
end

# Psych might NOT EXIST AT ALL
require 'yaml'

