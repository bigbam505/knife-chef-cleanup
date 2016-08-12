begin
  require "knife-chef-inventory/version"
  require "github_changelog_generator/task"

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = "v#{Knife::ChefInventory::VERSION}"
    config.issues = false
    config.enhancement_labels = %w(enhancement)
    config.bug_labels = %w(bug)
    config.exclude_labels = %w(cleanup duplicate question wontfix no_changelog)
  end
rescue LoadError
  puts "Problem loading gems please install chef and github_changelog_generator"
end
