require 'sinatra/base'
require 'mustache/sinatra'

$: << "./"
class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'views/hello'
  require 'views/document'
  require 'sqlite3'
  require 'patron'
  require 'nokogiri'

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
  get '/document*' do |path|
	#row=[{"table_schema" => path}]
	sess=Patron::Session.new
	sess.base_url="http://sellercentral.amazon.com/"
	response=sess.get path
	html_doc=Nokogiri::HTML(response.body)
	form=html_doc.css("form")
	row=[{"url" => html_doc.title, "body" => form}]
	
    Views::Document::have ( row )
    mustache :document, :layout => false
  end

  get '/nolayout' do
    content_type 'text/plain'
    mustache :nolayout, :layout => false
  end
end
