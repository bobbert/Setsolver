class User < ActiveRecord::Base
  has_many :players

  # gets full name, as string
  def name
    (fname.to_s + ' ' + lname.to_s).chomp ' '
  end

  # assigns full name, as string, and parses first and last names
  # from full name string.
  def name=( s_fullname )
    if ( (arr_name = s_fullname.split(', ')).length == 2 )
      (self.lname, self.fname) = arr_name
      return save
    end
    if ( (arr_name = s_fullname.split(' ')).length == 2 )
      (self.fname, self.lname) = arr_name
      return save
    end
    false
  end

  # get list of all games played in
  def games_played_in
    players.map {|pl| pl.game }
  end

end