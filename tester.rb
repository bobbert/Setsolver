# Developed by Robert Phelps
# old Setsolver auto-loader script used for  standalone Ruby application.
# as of 3/10/08, this is a Rails application.

def tester
  load 'setsolver.rb'
  sd = SetDeck.new
  sd.start
  sd.deal 12
  sd.find_set {|a| puts a.map {|i| sd.in_play[i].to_s }.join ', ' }
end
