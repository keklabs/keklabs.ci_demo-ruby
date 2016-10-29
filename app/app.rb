require 'sinatra'
#require 'rack/conneg'
#require 'erubis'
require 'erb'
#require 'json'
#require 'yaml'

enable :inline_templates

set :erb, escape_html: true


#use Rack::Conneg do |c|
#  c.set :accept_all_extensions, false
#  c.set :fallback, nil  
#  c.provide %i(html json yaml)
#end

get '/*' do
  echo
end

put '/*' do
  echo
end

post '/*' do
  echo
end

delete '/*' do
  echo
end

def data
  puts request.class
  puts request
  
 {
    request: request.env.select { |k,_| k =~ /^(?!HTTP_)[A-Z]/ },
    headers: request.env.select { |k,_| k =~ /^HTTP_/ },
    params: request.params,
    env:ENV
  }
end

def echo
#  respond_to do |wants|
#    wants.html do
    
      renderer = ERB.new(File.read(File.join(File.dirname(__FILE__),"/views/echo.rb")), 0, '>')
      renderer.result(OpenStruct.new({data: data}).instance_eval { binding })
          
    # erb :echo
#    end
#    wants.json do
#      JSON.pretty_generate data
#    end
#    wants.yaml do
#      YAML.dump data
#    end
#    wants.other do
#      content_type 'text/plain'
#      error 406, "Not Acceptable\n"
#    end
#  end 
end
