# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.
require File.expand_path("#{File.dirname(__FILE__)}/config/environment")

map ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  run DMPRoadmap::Application
end
