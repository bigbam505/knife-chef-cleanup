# frozen_string_literal: true
module KnifeChefInventory
  module Shared
    def time_since(timestamp)
      (Time.now - Time.at(timestamp)).to_i / 60
    end

    def search_nodes(query)
      Chef::Search::Query.new.search(:node, query, search_args).first
    end

    def max_results
      Chef::Node.list.count || 1000
    end
  end
end
