require 'rubygems'
require 'sinatra'
require 'active_record'
      
ROOT_DIR = File.dirname(__FILE__)

$config = YAML.load(File.read(ROOT_DIR + '/../config/qos.yaml'))

Dir[File.join(ROOT_DIR, "lib", "*")].each { |file| require file }

require 'haml'
require 'yaml'
require 'ostruct'

use Rack::Auth::Basic do |username, password|
  [username, password] == ['qos', 'immQOS']
end

Dir[File.join(ROOT_DIR, "app", "*")].each { |file| load file }
