#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Launchvn::Application.load_tasks

namespace :test do
  desc "Test workers"
  Rake::TestTask.new :workers do |t|
    t.libs << 'test'
    t.pattern = 'test/worker/**/*_test.rb'
    t.verbose = true
  end
end
