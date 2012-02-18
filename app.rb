require 'sinatra/base'
require 'mustache/sinatra'
require 'cgi'

$: << "./"
class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'views/document'
  require 'views/amazon'
  require 'views/bossservice'
  require 'views/bosspayment'
  require 'views/bossorders'
  require 'views/listing'
  require 'views/flist'
  require 'views/fieldedit'
  require 'sqlite3'
  require 'patron'
  require 'nokogiri'
  require 'queryparams'

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

  get '/document/boss/orders*' do |path|
    orders=Views::Bossorders::body
    #orders.each do|form|
    #end

    Views::Bossorders::have ( [{"body"=>orders}] )
    mustache :bossorders
  end
  get '/document/boss/payment*' do |path|
    @title = "BOSS Payment History Report"

    payments=Views::Bosspayment::body
    forms=[]
    payments.each do|form|
      info=form.xpath("fieldset")[0]
      detail=form.xpath("fieldset")[1]
      billing=form.xpath("fieldset")[2]
      comment=form.xpath("fieldset")[3]
      extra=form.xpath("fieldset")[4]
      #puts "####Info:####"
      #p info
      #puts "####Detail:####"
      #p detail
      #puts "####Billing:####"
      #p billing
      data={"info"=>info, "detail"=>detail, "billing"=>billing,
        "comment"=>comment, "extra"=>extra }
      forms << data
    end

    Views::Bosspayment::have ( [{"body"=>forms}] )
    mustache :bosspayment
  end
  get '/document/boss*' do |path|
    #test
  end

  #get '/document*' do
  #  row = @db.execute(
  #    "select * from to_document" )
  #  Views::Document::have ( row )
  #  mustache :document
  get '/document*' do |path|
    @title = "Amazon 120-days Order Report (raw)"

    Views::Document::have ( [Views::Amazon::body] )
    mustache :document
  end

=begin
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

# bad... try http://stackoverflow.com/a/7941044 QueryParams module
    key=CGI.escape("#{schema}.#{table}.#{column}")

    schema=@db.escape(schema)
    table=@db.escape(table)
    column=@db.escape(column)

    notes=@db.escape(params[:notes])
    status=@db.escape(params[:status])

    record = { "schema" => schema, "table" => table, "column" =>
      column, "notes" => notes, "status" => status }

    # the forbidden MySQL
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
=end
end
