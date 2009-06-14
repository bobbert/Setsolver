class GamesController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
    @game_pages, @games = paginate :games, :per_page => 10
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :play ],
  #       :redirect_to => { :action => :list }

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    if @game.save
      @caption = 'Game was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def destroy
    Game.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

#------ my controller methods ----#

  # the heart of the Setsolver game logic lies here.
  # This method handles new games, and all types of card submissions
  # (valid set, invalid set, wrong # of cards selected, etc.)
  def play
    @game = Game.find(params[:id])
    @sets = []
    @caption = nil
    if @game.deck
      @sets = @game.find_sets
      if params[:commit]  # user made submission
        selection = get_user_set_selection
        if selection.nil?
          @caption = 'You did not select three cards.'
        else
          @sets.each do |set|
            if selection == set
              @found_set = selection.map {|i| @game.cards[i] }
              @found_set.each {|c| @game.cards.delete c }
            end
          end
          @caption = 'The three cards you selected are not a set.' unless @found_set
        end
      end
    else # no deck
      new_deck
    end
@tmp = params.length
    populate_field unless @caption
    render :action => 'play'
  end

  # populates the playing field with FIELD_SIZE number of cards, unless
  # there are no more cards to add.
  def populate_field
    until (@game.cards.length >= Game::FIELD_SIZE)
      if @game.deck.length == 0
        new_deck
        cards_to_add = Game::FIELD_SIZE
      else
        cards_to_add = Game::FIELD_SIZE - @game.cards.length
      end
      deal cards_to_add if cards_to_add > 0
      @sets = @game.find_sets
      if @sets.empty?
        (0..2).to_a.map {|i| @game.cards[i] }.each do |c|
          @game.cards.delete c
        end
      end
    end
  end

  # deals num_cards number of cards from deck to game field, or deals
  # out the rest of the deck if num_cards exceeds the number of cards
  # in the deck.
  def deal( num_cards = 1 )
    num_cards = @game.deck.length if (@game.deck.length < num_cards.to_i)
    dealt = @game.deck.get_random_cards num_cards
    dealt.each do |c|
      @game.deck.cards.delete c
      @game.cards << c
    end
  end

  # creates a new full deck of cards
  def new_deck
    @game.cards.clear
    d = Deck.new
    @game.deck = d
    if d.save
      @game.deck_count += 1
      Card.find(:all).each {|c| @game.deck.cards << c }
      @game.save
    else
      return false
    end
  end

  # get user-submitted set as indices from params hash, from lowest to highest.
  # returns array if 3 cards selected, or nil if more or less than 
  # 3 cards selected.
  def get_user_set_selection
    retval = []
    @game.cards.each_index do |i|
      val = params[('card' + i.to_s)]
      retval << i if val && (val == 'SELECTED')
    end
    return nil if retval.length != 3
    retval
  end

end
