require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    @time = Time.now
    w = ("A".."Z").to_a
    @letters = (w + w).sample(10)
  end

  def score
    @letters = params[:letters].split
    grid_r = @letters.size
    @old_time = params[:time].to_time
    @h = { your_score: 0, message: "not an english word", time: Time.now - @old_time}
    params[:word].upcase.chars.each { |letter| @letters.delete_at(@letters.index(letter)) if @letters.include?(letter) }
    if english?(params[:word]) && params[:word].chars.size + @letters.size == grid_r
      @h[:your_score] = (params[:word].length / @h[:time]) * 100
      @h[:message] = "Well done"
    elsif params[:word].chars.size + @letters.size != grid_r
      @h[:message] = "not in the grid"
    end
  end

  private

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = RestClient.get(url)
    user = JSON.parse(user_serialized)
    return user["found"]
  end
end
