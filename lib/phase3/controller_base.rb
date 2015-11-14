require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
       controller_name =self.class.to_s.underscore
       #p controller_name
       file_path= "views/#{controller_name}/#{template_name}.html.erb"
       #p file_path
       
       file = File.open(file_path, "r")
       contents = file.read
       template = ERB.new(contents).result(binding)
       render_content(template, "text/html")
       
    end
  end
end
