# Developed by Robert Phelps
# old Setsolver: standalone Ruby application, and early test-bed version.
# as of 3/10/08, this is a Rails application.

# class SetCard: represents one card in a Set deck.  This class also contains
# class attributes for each card aspect and the possible types for each card aspect,
# and some deck-related attributes such as the maximum number of cards in a deck.
class SetCard

# class variables - accessible by all instances
@@aspects = { :number => [:one, :two, :three],
              :color => [:red, :green, :purple],
              :shading => [:outlined, :shaded, :filled],
              :shape => [:oval, :diamond, :squiggle]
}
# proper sequence of aspects
@@ord_aspects = [:number, :shading, :color, :shape]
#abbreviated aspect names
@@abbrev = { :one => '1', :two => '2', :three => '3',
             :red => 'Rd', :green => 'Gr', :purple => 'Pr',
             :outline => 'Ou', :shaded => 'Sh', :filled => 'Fi',
             :oval => 'Ov', :diamond => 'Di', :squiggle => 'Sq'
}
# calculate product of (number of values of each aspect), should be 3x3x3x3
@@numcards = @@aspects.values.inject(1) do |product,aspvals|
  product *= aspvals.length 
end

attr_reader *(@@aspects.keys)  # creating class attribute for each aspect
attr_reader :id
private :set_attrs_from_id

# class method - number of cards in deck
def self.numcards
  @@numcards
end
# class method - array of aspect types, ordered
def self.aspects
  @@ord_aspects
end

# class constructor - assigns ID then gets aspects from ID
def initialize(id = nil)
  @id = id.to_i if (1..@@numcards).include? id.to_i
  @id = (rand @@numcards).floor + 1 if @id.nil?
  set_attrs_from_id
end

# sets attributes (names found in array @@ord_aspects) given a valid ID number in @id
def set_attrs_from_id
  tmp_id = @id - 1  # convert ID to range (0..80) so that MOD arithmetic works
  @@ord_aspects.each do |type|
    asplen = @@aspects[type].length
    indx = tmp_id % asplen
    # a fancy way of setting attribute name 'type', keeps code DRY
    self.send((type.to_s + '='), @@aspects[type][indx])
    tmp_id /= asplen
  end
  @id
end

# returns the abbreviated name of the card using @@abbrev
def abbrev
  tmp_abbrev = @@ord_aspects.map do |type| 
    val = @@abbrev[(self.send type)]
  end
  tmp_abbrev.join
end

# image name, used to show picture
def img_name
  abbrev + '.jpg'
end

# human-readable name of card
def to_s
  plural = false
  tmp_vals = @@ord_aspects.map do |type| 
    val = self.send type
    if type == :number
      plural = ( @@abbrev[val].to_i > 1 )
      @@abbrev[val]
    else
      val.to_s
    end
  end
  (tmp_vals.join ' ') + ('s' if plural).to_s
end

# comparison operator - used for card array ordering, or sorting by ID
def <=>(other)
  self.id <=> other.id
end

# equality operator - are two cards equal?
def ==(other)
  self.id == other.id
end

end # class SetCard


# class SetDeck: represents the entire Set deck, both face down and in-play.
# Contains set-finding algorithms and routines to shuffle the deck,
# as well and finding and remove cards from the deck based on in-play actions.
class SetDeck

attr_reader :deck
attr_accessor :in_play

# class constructor - starting with default deck ordering (unshuffled)
def initialize
  # get a fresh new deck, in order from 1 to numcards
  @deck = (1..SetCard.numcards).to_a.map {|num| SetCard.new num }
  @in_play = []
end

# randomize card order within deck
def shuffle
  tempdeck = []
  @deck.length.downto(1) do |num|
    r = rand num
    # extracting item from deck array at index r
    tempdeck << @deck.slice!(r.floor)
  end
  @deck = tempdeck
end

# start new game with shuffled deck
def start
  initialize
  shuffle
end

# deal (num) number of cards to in-play array
def deal(num = 1)
  num.to_i.downto(1) {|i| @in_play << @deck.shift }
end

# clears cards in play - either one card (if an ID is passed in) or 
# a list of cards (if an array is passed in) or all cards (if ID parameter is nil)
def clear(id = nil)
  if id.nil? then
    @in_play.clear
  elsif id.is_a? Enumerable
    @in_play.delete_if {|c| i.include? c }
  else
    @in_play.delete_if {|c| c.id = id.to_i }
  end
end

# performs a ( len 3 ) statistical combination, where len is the length of the 
# in-play deck.  The combination is returned as an array-of-arrays, where the inner
# arrays are of length 3 and the outer array is length ( len 3 ) with distinct elements.
def each_cmb3
  len = @in_play.length
  retval = []
  # outermost loop: i = iterate from 0 to (len-1), add i to end of all arrays
  # middle loop: j = iterate from i to (len-1), add j to end of arrays
  # inner loop: create array with numbers (j+1) to (len-1), which may be empty.
  0.upto(len-1) do |i|
    (i+1).upto(len-1) do |j| 
      arr = ((j+1)..(len-1)).to_a
      arr.map! {|k| [i,j,k] }
      retval += arr 
    end
  end
  retval
end

# the h
def find_set
  cmb3_arr = each_cmb3
  SetCard.aspects.each do |asp|
    cmb3_arr.delete_if do |arr3|
      num_different_attr( asp, arr3.map {|num| @in_play[num] } ) == 2
    end
  end
  cmb3_arr.map! {|sa| yield sa } if block_given?
  cmb3_arr
end

def num_different_attr(asp, cards)
  res = cards.map {|c| c.send(asp) }
  res.uniq.length
end


end # class SetDeck


