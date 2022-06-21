require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess]
    begin
      if ! @game.guess(letter[0])
        flash[:message] = "You have already used that letter." 
      end
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  get '/show' do
    case @game.check_win_or_lose
    when :win then redirect '/win'
    when :lose then redirect '/lose'
    else erb :show
    end
  end
  
  get '/win' do
    if @game.check_win_or_lose == :win
      erb :win
    else
      redirect '/show'
    end
  end
  
  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      redirect '/show'
    end
  end
  
end