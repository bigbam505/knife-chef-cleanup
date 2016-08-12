
# frozen_string_literal: true
# Import other external rake tasks
Dir.glob("tasks/*.rake").each { |r| import r }

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task travis: [:rubocop]

task default: [:rubocop]
