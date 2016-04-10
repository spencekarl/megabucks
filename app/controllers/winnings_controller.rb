class WinningsController < ApplicationController
  def index
    my_numbers = [8, 14, 16, 33, 38, 48]
    my_doubler = 2
    @winners = []

    page = "http://www.masslottery.com/data/json/games/lottery/11.json"
    contents = open(page).read
    results = JSON.parse(contents)

    @winning_numbers = results["draws"][2]["winning_num"].split("-")
    @winning_numbers.each { |num| @winners << num if my_numbers.include?(num.to_i) }
    @did_i_win = (@winners.length < 3) ? "no" : "yes"
  end
end
