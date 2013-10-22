require 'sinatra'
require 'slim'
require 'debugger'

require "sinatra"
require "sinatra/activerecord"

require "sinatra/json"
require "json"

require "./middlewares/chat_backend.rb"
use ChatDemo::ChatBackend

configure :development do
  #set :db, File.join("sqlite3://",settings.root, "development.db"
  set :database, "sqlite3:///morpy.db"
end

configure :test do
  set :database, "sqlite3:///morpy.db"
end

class Game < ActiveRecord::Base
  has_many :moves

  serialize :squares, Array
  validates :squares, presence: true
end

class Move < ActiveRecord::Base
  belongs_to :game

  validates :coordinate, presence: true
  validates :game_id, presence: true
end

def all_equal?(*elements)
  elements.all? { |x| x == elements.first }
end

def define(rows)
  # params[:move] => [0, 0]
  @symbol = if rows.flatten.compact.select {|str| str == 'X' }.count > rows.flatten.compact.select {|str| str == 'O' }.count
    'O'
  else
    'X'
  end
end

delete '/game' do
  if @game = Game.first
    @game.destroy
  end
end

put '/game' do
  squares = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
  @game = Game.new({squares: squares})
  @game.save
end

post '/game' do
  # params[:squares] = (0..8).v
  
end

delete '/game' do
  game = Game.first
  game.destroy
end

get '/game/moves' do
  @rows = Game.first.squares
  define(@rows)
  slim :'index.html'
end

post '/game/moves' do
  clients = ChatDemo::ChatBackend::clients
  clients.each {|ws| ws.send('test') }

  # params[:coordinate]
  if params[:square]
    a = Game.first
    a.squares[params[:square][0].to_i][params[:square][1].to_i] = define(a.squares)
    a.save
    # sending alert to clients

    define(a.squares)
  end
end

get "/assets/js/application.js" do
  content_type :js
  @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
  erb :"application.js"
end
