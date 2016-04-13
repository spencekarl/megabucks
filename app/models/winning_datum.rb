class WinningDatum < ActiveRecord::Base

  def initialize
    @my_numbers = [1, 11, 16, 29, 12, 23]
    @my_doubler = 2
    @matching_numbers = 0

    file = open("http://www.masslottery.com/data/json/games/lottery/11.json").read
    data = JSON.parse(file)
    @weekly_draw = data["draws"][0]
    winning_numbers = @weekly_draw["winning_num"].split("-")
    winning_numbers.each { |num| @matching_numbers += 1 if @my_numbers.include?(num.to_i) }
  end

  # .is_winner? returns boolean (winner or loser) based on user's matching numbers
  def is_winner?
    return (@matching_numbers >= 3) ? true : false
  end

  # .announcement returns random string announcing whether the user won or lost
  def announcement
    winner = ["holy sh!t, you won!!",
              "you're a winner harry",
              "wtf, you actually won!",
              "hell yeah!!!!",
              "finally :)",
              "you did it!" ]
    loser  = ["another week, another loss",
              "did you really think the odds were in your favor?",
              "you're a loser, again",
              "maybe next week :-(",
              "you get nothing!",
              "i guess your numbers kinda suck"]
    return is_winner? ? winner.sample.upcase : loser.sample.upcase
  end

  # .prize returns integer prize amount based on user's matching numbers + bonus
  def prize
    return 0 if !is_winner?

    prizes = [0, 0, 0, 2, 100, 2500, @weekly_draw["jackpot"].delete("$,").to_i]
    bonus_multiplier = (@weekly_draw["bonus"].to_i == @my_doubler && @matching_numbers < 6) ? 2 : 1
    return prizes[@matching_numbers] * bonus_multiplier
  end

  # .video returns string for url of youtube video
  def video
    youtube_params = "?autoplay=1&showinfo=0&autohide=1&controls=0&playlist=skf8mvqFqSo&loop=1"
    return "//www.youtube.com/embed/" + @weekly_draw["video_id"] + youtube_params
  end

end
