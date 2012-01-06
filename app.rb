require 'sinatra/base'
require 'mustache/sinatra'
require 'uri'

$: << "./"
class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'views/document'
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

  def pluck(str,elem)
    elem.xpath("//input[@name='#{str}']/@value").first.value
  end

  def visit_unshipped(sess)
    sess.get "/gp/orders-v2/list/ref=ag_myo_doa1_home?ie=UTF8&searchType=OrderStatus&ignoreSearchType=1&statusFilter=ItemsToShip&searchFulfillers=mfn&preSelectedRange=37&searchDateOption=preSelected&sortBy=OrderStatusDescending"
  end

  def visit_amazon(sess)
    sess.timeout=10
    sess.handle_cookies("cookies.txt")
    sess.base_url="http://sellercentral.amazon.com/"
    response=sess.get "/gp/homepage.html"
  end

  def build_login(form)
    sessid=pluck("session-id", form)
    protocol=pluck("protocol", form)
    action=pluck("action", form)
    email="kingdon@tuesdaystudios.com"
    destination=pluck("destination", form)
    optin=pluck("optin", form)
    ouid=pluck("ouid", form)

    data={ "session-id" => sessid, "protocol" => protocol, "action" => action, 
      "email" => email, "destination" => destination, "optin" => optin,
      "ouid" => ouid, "password" => File.new("pass","r").gets }
    param=QueryParams.encode(data)
  end

  def login_amazon
    sess=Patron::Session.new
    response=visit_amazon(sess)
    html_doc=Nokogiri::HTML(response.body)
    form=html_doc.css("form")
    param=build_login(form)
    login=sess.post "/gp/sign-in/sign-in.html/ref=ag_login_lgin_home", param
    #html_doc=Nokogiri::HTML(login.body)
    sess
  end

  # unshipped, neworders
  # methods to request an order report is generated.
  # what happens if you call them too often?
  def unshipped(sess)
    sess.post("/gp/upload-download-utils/requestReport.html",
      QueryParams.encode({ "type" => "UnshippedOrders" }))
  end
  def neworders(sess)
    sess.post("/gp/upload-download-utils/requestReport.html",
      QueryParams.encode({ "type" => "Orders", "days" => "30" }))
  end
  def order_pickup(sess)
    sess.get("/gp/transactions/orderPickup.html").body
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
    sess = login_amazon
    orders_page=visit_unshipped(sess)

    html_doc=Nokogiri::HTML(orders_page.body)
    content=html_doc.css("table.data-display")
    #login=sess.post "/gp/sign-in/sign-in.html/ref=ag_login_lgin_home", param


    #order=order_pickup(login_amazon)
    #row=[{"body" => order}] #[{"body" => "success"}]
    Views::Document::have ( [{"body"=>content}] )
    mustache :document, :layout => false
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

    key=URI.escape("#{schema}.#{table}.#{column}")

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
