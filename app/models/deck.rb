class Deck < ActiveRecord::Base
  has_and_belongs_to_many :cards
  belongs_to :game

  # Returns an array of randomly selected Card objects, length "numcards".
  # The Card objects returned by this method are not removed from the deck.
  def get_random_cards( numcards = 1 )
    dealt = []
    return cards.to_a if numcards.to_i >= cards.length
    id_list = cards.map {|c| c.id }
    numcards.to_i.downto(1) do |num|
      rnd = rand id_list.length
      dealt << Card.find( id_list.slice!(rnd.floor) )
    end
    dealt
  end

  # the deck length
  def length
    cards.length
  end

  # true if deck is empty
  def empty?
    cards.empty?
  end

end
