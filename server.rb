require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require './models/board'

BOARD = Board.initialize_from_file('test.txt')

get '/' do
  erb :index
end

post '/new_board' do
  BOARD = Board.initialize_from_io(params['board'][:tempfile])
  redirect '/'
end

# TODO:  Support scoping by x/y bounds
get '/board' do
  json :board => BOARD.to_a
end


# TODO:  Support scoping by x/y bounds
post '/board/run' do
  BOARD.run_generation
  'ok'
end
