require "chef/knife"

class Chef
  class Knife
    class CleanupCookbook < Knife
      banner "knife cleanup cookbook"

      deps do
        require "chef/search/query"
        require "chef/knife/search"
      end

      def run
        @cookbook_name = name_args[0]

        unless @cookbook_name
          ui.error "You need to specify a cookbook"
          exit 1
        end

        ui.info "Total Nodes using Cookbook: #{total_cookbook_usage}"
        ui.info "Cookbook Versions being used"
        ui.info cookbook_usage_per_version
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

      def cookbook_usage_per_version
        versions = []
        counts = Hash.new(0)
        cookbook_nodes.each do |node|
          name = node.name
          version = node.cookbooks[@cookbook_name].version

          counts[version] += 1
          versions.push(node: name, version: version)
        end

        counts
      end

      def total_cookbook_usage
        cookbook_nodes.length
      end
    end
  end
end
