module Rails
  module Generator
    module Commands
      class Create < Base
        def route_resource(*resources)
          resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
          sentinel = 'ActionController::Routing::Routes.draw do |map|'

          logger.route "map.resource #{resource_list}"
          unless options[:pretend]
            gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
              "#{match}\n  map.resource #{resource_list}\n"
            end
          end
        end
      end
    end
  end
end