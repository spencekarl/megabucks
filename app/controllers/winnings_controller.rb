class WinningsController < ApplicationController

  def index
    @megabucks = WinningDatum.new
  end

end
