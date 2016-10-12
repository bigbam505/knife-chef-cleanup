# frozen_string_literal: true
require "chef/knife"
require "knife-chef-inventory/shared"

class Chef
  class Knife
    class InventoryChefClient < Knife
      include KnifeChefInventory::Shared
      banner "knife inventory chef_client"

      deps do
        require "chef/search/query"
        require "chef/knife/search"
      end

      def run
        @client_version = name_args[0]

        if @client_version
          output_version_analysis
        else
          output_analysis
        end
      end

      attr_reader :client_version

      private

      attr_writer :client_version

      def all_nodes
        @all_nodes ||= search_nodes("chef_packages_chef_version:*")
      end

      def client_version_nodes
        @client_version_nodes ||= search_nodes("chef_packages_chef_version:#{@client_version}")
      end

      def search_args
        {
          rows: max_results,
          filter_result: {
            name: ["name"],
            chef_version: %w(chef_packages chef version),
            ohai_time: ["ohai_time"]
          }
        }
      end

      def client_usage_per_version
        version_map = Hash.new(0)
        all_nodes.each do |node|
          version = node["chef_version"]

          version_map[version] += 1
        end

        version_map
      end

      def all_versions
        @all_versions ||= client_usage_per_version.keys.uniq.sort
      end

      def analyze_version(version)
        client_usage = client_usage_per_version[version]
        return unless  client_usage

        ui.info "#{version} is used by #{client_usage} hosts" if client_usage.positive?
      end

      def output_version_analysis
        ui.info "Client Versions being used"
        client_version_nodes.sort_by { |node| node["ohai_time"] }.each do |node|
          ui.info "#{node['name']} - #{time_since(node['ohai_time'])} Minutes"
        end
      end

      def output_analysis
        all_versions.each do |version|
          analyze_version(version)
        end
      end
    end
  end
end
