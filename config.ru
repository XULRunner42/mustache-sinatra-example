$: << File.dirname(__FILE__)

require 'app'

use Rack::ShowExceptions

run App.new