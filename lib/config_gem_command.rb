module Rails
  module Generator
    module Commands
      class Create < Base
        def config_gem(name, options={})
          sentinel = 'Rails::Initializer.run do |config|'
          name_and_options = name.inspect
          name_and_options << ", #{options.inspect}" if options.any?
          logger.route "config.gem #{name_and_options}"
          unless options[:pretend]
            gsub_file 'config/environment.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
              "#{match}\n  config.gem #{name_and_options}\n"
            end
          end
        end
      end
    end
  end
end