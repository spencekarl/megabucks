class WinningsController < ApplicationController
  def index
    my_numbers = [8, 14, 16, 33, 38, 48]
    my_doubler = 2
    winning_count = 0
    prizes = { 3 => 2,
               4 => 100,
               5 => 2500,
               6 => 500000 }
    phrases = { :winner => ["holy sh!t, you won!!",
                            "you're a wizard harry.. i mean, a winner",
                            "wtf, you actually won!",
                            "hell yeah!!!!",
                            "finally :)"],
                :loser  => ["another week, another loser",
                            "did you really think the odds were in your favor?",
                            "you're a loser, again",
                            "maybe next week :()",
                            "you won...$0",
                            "$zero"] }

    # open json lottery data page and parse results into ruby array
    page = "http://www.masslottery.com/data/json/games/lottery/11.json"
    contents = open(page).read
    results = JSON.parse(contents)

    # store winning numbers, jackpot, bonus, and weekly video
    @winning_numbers = results["draws"][0]["winning_num"].split("-")
    prizes[6] = results["draws"][0]["jackpot"]
    @bonus_number = results["draws"][0]["bonus"]
    @video_id = results["draws"][0]["video_id"]
    @video_url = "//www.youtube.com/embed/" + @video_id + "?autoplay=1&showinfo=0&autohide=1&controls=0&playlist=skf8mvqFqSo&loop=1"

    # determine if i won
    @winning_numbers.each { |num| winning_count += 1 if my_numbers.include?(num.to_i) }
    @i_won = (winning_count >= 3) ? :winner : :loser
    bonus_multiplier = (@bonus_number.to_i == my_doubler && winning_count < 6) ? 2 : 1

    # determine winning/losing phrase
    @announcement = phrases[@i_won].sample.upcase

    # determine winning amount
    @winnings = prizes[winning_count] * bonus_multiplier if @i_won == :winner

  end
end
