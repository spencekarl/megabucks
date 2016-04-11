class WinningsController < ApplicationController
  def index
    #my_numbers = [8, 14, 16, 33, 38, 48]
    my_numbers = [1, 11, 16, 29, 12, 50]
    my_doubler = 2
    winning_count = 0
    prizes = [0, 0, 0, 2, 100, 2500, 500000]
    phrases = { :winner => ["holy sh!t, you won!!",
                            "you're a winner harry",
                            "wtf, you actually won!",
                            "hell yeah!!!!",
                            "finally :)",
                            "you did it!"],
                :loser  => ["another week, another loss",
                            "did you really think the odds were in your favor?",
                            "you're a loser, again",
                            "maybe next week :-(",
                            "you get nothing!",
                            "i guess your numbers kinda suck"] }
    week = 0

    # open json lottery data page and parse data into ruby array
    page = "http://www.masslottery.com/data/json/games/lottery/11.json"
    contents = open(page).read
    data = JSON.parse(contents)

    # store winning numbers, bonus, jackpot
    winning_numbers = data["draws"][week]["winning_num"].split("-")
    bonus_number = data["draws"][week]["bonus"].to_i
    prizes[6] = data["draws"][week]["jackpot"].delete "$"
    # build video url
    video_id = data["draws"][week]["video_id"]
    youtube_params = "?autoplay=1&showinfo=0&autohide=1&controls=0&playlist=skf8mvqFqSo&loop=1"
    @video_url = "//www.youtube.com/embed/" + video_id + youtube_params

    # determine if i won
    winning_numbers.each { |num| winning_count += 1 if my_numbers.include?(num.to_i) }
    @winner_loser = (prizes[winning_count] > 0) ? :winner : :loser
    bonus_multiplier = (bonus_number == my_doubler && winning_count < 6) ? 2 : 1

    # determine winning/losing phrase
    @announcement = phrases[@winner_loser].sample.upcase

    # determine winning amount
    @winnings = prizes[winning_count] * bonus_multiplier if @winner_loser == :winner
  end
end
