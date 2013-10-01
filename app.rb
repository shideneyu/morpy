require 'sinatra'
require 'slim'
require 'debugger'

def define
  # params[:move] => [0, 0]
  @symbol = if @rows.flatten.compact.select {|str| str == 'X' }.count > @rows.flatten.compact.select {|str| str == 'O' }.count
    'O'
  else
    'X'
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
  @rows = [
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil]
  ]


 
  params[:move].each_slice(2).to_a.each do |j, k|
    define
    @rows[j.to_i][k.to_i] = @symbol
  end

slim :'index.html'
end

