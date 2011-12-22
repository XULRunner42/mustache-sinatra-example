require 'sinatra/base'
require 'mustache/sinatra'

$: << "./"
class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'views/hello'
  require 'views/document'
  require 'sqlite3'

  def initialize
    super
    @db=SQLite3::Database.new( "test.db" )
    @db.results_as_hash=true
  end

  set :mustache, {
    :views     => 'views/',
    :templates => 'templates/'
  }

  get '/' do
    @title = "Mustache + Sinatra = Wonder"
    mustache :index
  end

  get '/other' do
    mustache :other
  end

  get '/hello' do
    mustache :hello
  end
  post '/hello' do
    Views::Hello::have ([params[:foo], params[:bar], params[:baz]])
    mustache :hello
  end
  get '/document*' do
    row = @db.execute(
      "select * from to_document" )
    Views::Document::have ( row )
    mustache :document
  end

  get '/nolayout' do
    content_type 'text/plain'
    mustache :nolayout, :layout => false
  end
end
