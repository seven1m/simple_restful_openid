require File.dirname(__FILE__) + '/../../lib/route_resource_command.rb'
require File.dirname(__FILE__) + '/../../lib/config_gem_command.rb'

class SimpleRestfulOpenidGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.class_collisions 'Session'
      m.file 'sessions_controller.rb', 'app/controllers/sessions_controller.rb'
      m.directory 'app/views/sessions'
      m.file 'new.html.erb', 'app/views/sessions/new.html.erb'
      m.route_resource :session
      m.config_gem 'ruby-openid', :version => '>= 2.0', :lib => 'openid/consumer'
    end
  end
end

