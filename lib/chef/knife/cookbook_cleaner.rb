require "chef/knife"

class Chef
  class Knife
    class CookbookCleaner < Knife
      banner "knife cookbook cleaner"

      def run
        ui.info "I AM ALIVE"
      end
    end
  end
end
