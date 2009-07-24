class GamesController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
    @game_pages, @games = paginate :games, :per_page => 10
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenT;new, oUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :play, :refresh],
  # :redirect_to => { :action => :list }

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
  # (valid set, invalid set, wrong # of cards selected, etc. )
  def play
    @game = Game.find(params[:id])
    @sets = @game.find_sets
    @caption = nil
    # start with brand new first deck if not found, or user
    # did not submit (initial loading)
    if !(@game.deck && params[:commit])
      new_deck unless @game.deck
      populate_field
      render :action => 'play'
    else
      selection = get_card_numbers
      if selection.length != 3
        @caption = 'You did not select three cards.'
      elsif !(@sets.include? selection)
        @caption = 'The three cards you selected are not a set.'
      else
        @sets.each do |set|
          if selection === set
            @found_set = selection.map {|i| @game.cards[i] }
            @found_set.each {|c| @game.cards.delete c }
          end
        end
      end
      populate_field unless @caption
      render :action => '_gamefield'
    end
  end

  # get card numbers from params hash that takes the following form:
  # key = :card<number>, value = "SELECTED"
  # The array of card numbers is always in numerical order.
  def get_card_numbers
    cards = params.clone.delete_if do |k,v|
      (v.to_s != 'SELECTED') || (k.to_s !~ /^card[0-9]+$/)
    end
    nums = cards.map {|cs| cs.to_s.sub(/^card/,'').to_i }.sort
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
    @game.save
  end

  # get HTML table with all active set cards in the table cells
  def refresh
    @game = Game.find(params[:id])
    render :action => '_board'
  end

end
