require 'json'

class ApplicationController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views/") }

  get '/index' do
    computer_list = WordList.new(comp_dictionary)
    @computer_word = Word.new(computer_list.random_word)
    erb :'index'
  end

  post '/guesses' do
    # binding.pry
    count = Word.new(params[:guess][:word]).compare(params[:guess][:computer_word])
    word = params[:guess][:word]
    content_type :json
    {word: word, count: count}.to_json
  end

  post '/words' do
    # binding.pry
    !!(WordList.new(dictionary).word_sort.include?(params[:guess][:word].downcase)) ? "true" : "false"
  end

  # post '/help' do
  #   # binding.pry
  #   File.read('app/views/directions.html')
  # end

  get '/guesses' do

  end

end
