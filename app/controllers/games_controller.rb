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

  def create
    @game = Game.new(params[:game])
    @game.autoshuffle = 'Y' unless params[:noshuffle]
    if @game.save
      @caption = 'Game was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

#------ my controller methods ----#

  # the heart of the Setsolver game logic lies here.
  # This method handles new games, and all types of card submissions
  # (valid set, invalid set, wrong # of cards selected, etc. )
  def play
    @game = Game.find(params[:id])
    @count = @game.set_count
    # checking if initial page loading or user-submitted load
    if params[:commit]
      selection = get_card_numbers
      if selection.length != 3
        @caption = 'You did not select three cards.'
      else
	@found_set = make_set_selection( 1, *selection )
        @caption = 'The three cards you selected are not a set.' unless @found_set
      end
      @game.fill_game_field unless @caption
      render :action => '_gamefield'
    else
      @game.fill_game_field
      render :action => 'play'
    end
  end

  # get HTML table with all active set cards in the table cells
  def refresh
    @game = Game.find(params[:id])
    render :action => '_board'
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

end
