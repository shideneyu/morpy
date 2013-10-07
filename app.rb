require 'sinatra'
require 'slim'
require 'debugger'

require "sinatra"
require "sinatra/activerecord"

require "sinatra/json"
require "json"
 
set :database, "sqlite3:///morpy.db"

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

def define
  # params[:move] => [0, 0]
  @symbol = if @rows.flatten.compact.select {|str| str == 'X' }.count > @rows.flatten.compact.select {|str| str == 'O' }.count
    'O'
  else
    'X'
  end
end

get '/game' do
  @game = Game.first
end

post '/game' do
  # params[:squares] = (0..8).v
  unless @game = Game.first
    squares = if params[:squares].nil? || params[:squares].class != Array
      [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    else
      params[:squares]
    end

    @game = Game.new({squares: squares})
    @game.save
  end
end

delete '/game' do
  game = Game.first
  game.destroy
end

get '/game/moves' do
   @rows = [
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil]
  ]

  if params[:move]
    params[:move].each_slice(2).to_a.each do |j, k|
      define
      @rows[j.to_i][k.to_i] = @symbol
    end
  end

  slim :'index.html'
end

post '/game/moves' do
  # params[:coordinate]
  if params[:square]
    a = Game.first
    a.squares[params[:square][0].to_i][params[:square][1].to_i] = "X"
    a.save
  end
end







get "/" do
  @rows = [
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil]
  ]
  slim :'index.html'
end

get '/move' do
 
end

