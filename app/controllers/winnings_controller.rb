class WinningsController < ApplicationController
  def index
    page = "http://www.masslottery.com/data/json/games/lottery/11.json"
    contents = open(page).read
    results = JSON.parse(contents)

    @winning_numbers = results["draws"][0]["winning_num"]
#    binding.pry
  end
end
