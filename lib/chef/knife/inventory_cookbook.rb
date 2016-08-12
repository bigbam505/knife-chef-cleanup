# frozen_string_literal: true
require "chef/knife"

class Chef
  class Knife
    class InventoryCookbook < Knife
      banner "knife inventory cookbook COOKBOOK [VERSION] (options)"

      deps do
        require "chef/search/query"
        require "chef/knife/search"
        require "chef/cookbook_version"
        require "chef/environment"
      end

      option :env_constraints, short: "-c",
                               long: "--env-constraints",
                               description: "Show any environment constraints",
                               boolean: true,
                               default: false

      def run
        @cookbook_name = name_args[0]
        @cookbook_version = name_args[1]
        @show_env_constraints = config[:env_constraints]

        unless @cookbook_name
          ui.error "You need to specify a cookbook"
          exit 1
        end

        if @cookbook_version
          output_version_analysis
        else
          output_analysis
        end
      end

      attr_reader :cookbook_name
      attr_reader :cookbook_version

      private

      attr_writer :cookbook_name
      attr_writer :cookbook_version

      def cookbook_nodes
        @cookbook_nodes ||= search_nodes("cookbooks_#{@cookbook_name}:*")
      end

      def cookbook_version_nodes
        @cookbook_version_nodes ||=
          search_nodes("cookbooks_#{@cookbook_name}_version:#{@cookbook_version}")
      end

      def environment_versions
        unless @environment_versions
          @environment_versions = {}
          Chef::Environment.list.each do |env_name, _url|
            env = Chef::Environment.load(env_name)
            if env.cookbook_versions[@cookbook_name]
              @environment_versions[env.name] = env.cookbook_versions[@cookbook_name]
            end
          end
        end

        @environment_versions
      end

      def search_nodes(query)
        Chef::Search::Query.new.search(:node, query).first
      end

      def all_cookbook_versions
        @all_cookbook_versions ||= Chef::CookbookVersion.available_versions(@cookbook_name).sort
      end

      def cookbook_usage_per_version
        version_map = Hash.new(0)
        cookbook_nodes.each do |node|
          version = node.cookbooks[@cookbook_name].version

          version_map[version] += 1
        end

        version_map
      end

      def total_cookbook_usage
        cookbook_nodes.length
      end

      def analyze_version(version)
        cookbook_usage = cookbook_usage_per_version[version]
        if cookbook_usage
          ui.info "#{version} is used by #{cookbook_usage} hosts" if cookbook_usage.positive?
        end
      end

      def analyze_environments
        ui.info "Environment Version Constraints for #{@cookbook_name}"
        environment_versions.each do |env, constraint|
          ui.info "#{env} - #{constraint}"
        end
      end

      def time_since(timestamp)
        (Time.now - Time.at(timestamp)).to_i / 60
      end

      def output_version_analysis
        ui.info "Cookbook Versions being used for #{@cookbook_name}"
        cookbook_version_nodes.sort_by(&:ohai_time).each do |node|
          ui.info "#{node.name} - #{time_since(node.ohai_time)} Minutes"
        end
      end

      def output_analysis
        ui.info "Total Nodes using Cookbook: #{total_cookbook_usage}"
        all_cookbook_versions.each do |version|
          analyze_version(version)
        end

        analyze_environments if @show_env_constraints && environment_versions.any?
      end
    end
  end
end
