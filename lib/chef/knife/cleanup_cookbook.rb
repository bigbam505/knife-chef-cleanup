require "chef/knife"

class Chef
  class Knife
    class CleanupCookbook < Knife
      banner "knife cleanup cookbook"

      deps do
        require "chef/search/query"
        require "chef/knife/search"
        require "chef/cookbook_version"
      end

      def run
        @cookbook_name = name_args[0]

        unless @cookbook_name
          ui.error "You need to specify a cookbook"
          exit 1
        end

        output_analysis
      end

      attr_reader :cookbook_name

      private

      attr_writer :cookbook_name

      def cookbook_nodes
        @cookbook_nodes ||= search_nodes("cookbooks_#{@cookbook_name}:*")
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

      def output_analysis
        ui.info "Total Nodes using Cookbook: #{total_cookbook_usage}"
        ui.info "Cookbook Versions being used for #{@cookbook_name}"
        all_cookbook_versions.each do |version|
          cookbook_usage = cookbook_usage_per_version[version]
          ui.info "#{version} is not used" unless cookbook_usage
          ui.info "#{version} is used by #{cookbook_usage} hosts" if cookbook_usage
        end
      end
    end
  end
end
