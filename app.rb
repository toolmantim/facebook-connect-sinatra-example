require 'rubygems'
require 'sinatra'

require 'facebooker'

raise "No api_keys.yml was found" unless File.exist?(api_keys_file = "api_keys.yml")

$keys = YAML.load(File.read(api_keys_file))
$api_key, $secret_key = $keys['api_key'], $keys['secret_key']

helpers do
  def logged_in?
    facebook_user
  end
  def facebook_user
    @facebook_user ||= if request.cookies[$api_key]
      fb_session = Facebooker::Session.new($api_key, $secret_key)
      fb_session.secure_with! *%w(session_key user expires ss).map {|k| request.cookies[$api_key + "_" + k]}
      fb_session.user
    end
  end
end

get '/' do
  haml :index
end

get '/connect' do
  haml :connect
end
