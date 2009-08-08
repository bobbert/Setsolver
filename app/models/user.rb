class User < ActiveRecord::Base
  has_many :players

  # full name, as string
  def name
    (fname.to_s + ' ' + lname.to_s).chomp ' '
  end

  # get list of all games played in
  def games_played_in
    players.map {|pl| pl.game }
  end

end
