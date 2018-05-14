require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score

    @text_input = params[:shot].upcase.split("")
    new_letters = params[:letters].gsub(/\s+/, "").split("")

    matching_letters = @text_input.select do |letter|
      new_letters.include?(letter)
    end

    unmatching_letters = @text_input.reject do |letter|
      new_letters.include?(letter)
    end

    filepath = "https://wagon-dictionary.herokuapp.com/#{params[:shot].upcase}"
    serialized_data = open(filepath).read
    data = JSON.parse(serialized_data)
    @word = data["word"]
    @length = data["length"]
    @time = Time.now - Time.parse(params[:time])

    if unmatching_letters.length != 0
      @result = "The letters did not match the grid!"
      @score = 0
    elsif data["found"] == false
      @result = "Your word matches the grid but is not in the dictionary"
      @score = 0
    else
      @result = "Match!"
      @score = data["length"] * 10 + (60 - @time).round()
    end
  end
end
