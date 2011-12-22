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

  def login_amazon
    sess=Patron::Session.new
    sess.base_url="http://sellercentral.amazon.com/"
    response=sess.get "/gp/homepage.html"
    html_doc=Nokogiri::HTML(response.body)
    form=html_doc.css("form")
    sessid=form.xpath("//input[@name='session-id']/@value").first.value

    row=[{"protocol" => "https", "action" => "sign-in",
      "sessid" => sessid, "email" => "kingdon@tuesdaystudios.com",
      "destination" => "https://sellercentral.amazon.com/gp/homepage.html?ie=UTF8&amp;%2AVersion%2A=1&amp;%2Aentries%2A=0",
      "optin" => "1", "ouid" => "01", "password" => File.new("pass","r").gets }]
    puts row
    row
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
    row=[{"body" => login_amazon[0]["password"]}]
    Views::Document::have ( row )
    mustache :document, :layout => false
  end

  get '/nolayout' do
    content_type 'text/plain'
    mustache :nolayout, :layout => false
  end
end
