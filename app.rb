require 'sinatra/base'
require 'mustache/sinatra'
require 'cgi'

$: << "./"
class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'views/document'
  require 'views/amazon'
  require 'views/listing'
  require 'views/flist'
  require 'views/fieldedit'
  require 'sqlite3'
  require 'patron'
  require 'nokogiri'
  require 'queryparams'
  require 'mysql2'

  def initialize
    super
    @file=SQLite3::Database.new( "test.db" )
    @file.results_as_hash=true
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

  #get '/document*' do
  #  row = @db.execute(
  #    "select * from to_document" )
  #  Views::Document::have ( row )
  #  mustache :document
  get '/document*' do |path|
    @title = "Amazon Unshipped Order Report (raw)"

    Views::Document::have ( [{"body"=>Views::Amazon::body}] )
    mustache :document
  end

  get '/reports/undocumented/tables/mmi' do
    param={"table_schema"=>"mmi1"}

    Views::Listing::have(
      Views::Listing::data(@db, param) )

    mustache :listing
  end

  post '/reports/undocumented/fields/*.*.*' do
    schema=params[:splat][0]
    table=params[:splat][1]
    column=params[:splat][2]

    key=CGI.escape("#{schema}.#{table}.#{column}")

    schema=@db.escape(schema)
    table=@db.escape(table)
    column=@db.escape(column)

    notes=@db.escape(params[:notes])
    status=@db.escape(params[:status])

    record = { "schema" => schema, "table" => table, "column" =>
      column, "notes" => notes, "status" => status }

    Views::Fieldedit::update(db, record)

    redirect "/reports/undocumented/fields/#{key}"
  end

  get '/reports/undocumented/fields/*.*.*' do
    Views::Fieldedit::have ( Views::Fieldedit::row(@db, params) ) 
    mustache :fieldedit
  end

  get '/reports/undocumented/fields/*.*' do
    data=Views::Flist::rows(@db, params)

    Views::Flist::have ( data )
    mustache :flist
  end

  get '/nolayout' do
    content_type 'text/plain'
    mustache :nolayout, :layout => false
  end
end
