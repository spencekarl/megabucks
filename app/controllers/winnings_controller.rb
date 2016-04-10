class WinningsController < ApplicationController
  def index
    my_numbers = [1, 11, 16, 33, 38, 48]
    my_doubler = 6
    winning_count = 0
    prizes = { 3 => 2,
               4 => 100,
               5 => 2500,
               6 => 500000 }
    phrase = { :winner => ["win", "winner", "winning"],
               :loser  => ["lose", "loser", "losing"] }

    # open json lottery data page and parse results into ruby array
    page = "http://www.masslottery.com/data/json/games/lottery/11.json"
    contents = open(page).read
    results = JSON.parse(contents)

    # store winning numbers, jackpot, bonus
    @winning_numbers = results["draws"][0]["winning_num"].split("-")
    prizes[6] = results["draws"][0]["jackpot"]
    @bonus_number = results["draws"][0]["bonus"]

    # determine if i won
    @winning_numbers.each { |num| winning_count += 1 if my_numbers.include?(num.to_i) }
    @i_won = (winning_count >= 3) ? :winner : :loser
    bonus_multiplier = (@bonus_number.to_i == my_doubler && winning_count < 6) ? 2 : 1

    # determine winning/losing phrase
    @announcement = phrase[@i_won].sample
    # determine winning amount
    @winnings = prizes[winning_count] * bonus_multiplier if @i_won

  end
end
