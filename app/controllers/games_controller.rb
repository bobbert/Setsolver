class GamesController < ApplicationController

  before_filter :get_player_and_game

  # GET /players/1/games
  # GET /players/1/games.xml
  def index
    # listing all games within selected player
    @games = @player.games

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /players/1/games/1
  # GET /players/1/games/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /players/1/games/new
  # GET /players/1/games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /players/1/games/1/edit
  def edit
    true
  end

  # POST /players/1/games
  # POST /players/1/games.xml
  def create
    # create game and save, then add Score connector
    @game = Game.new(params[:game])

    respond_to do |format|
      # creating new game, and new association between selected player and game
      if @game.save && @game.add_player(@player)
        flash[:notice] = 'Game was successfully created.'
        format.html { redirect_to([@player, @game]) }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1/games/1
  # PUT /players/1/games/1.xml
  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        flash[:notice] = 'Game was successfully updated.'
        format.html { redirect_to([@player, @game]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1/games/1
  # DELETE /players/1/games/1.xml
  def destroy
    # delete Score first, then Game
    @score.destroy if @score
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(player_games_url) }
      format.xml  { head :ok }
    end
  end

#------ my controller methods ----#

  # plays submitted Set cards if submit button was clicked, then refreshes board
  def play
    @game.start unless @game.started?
    play_cards if params[:commit]  # play submitted cards, if a form submit occurred
    @sets = @game.fill_gamefield_with_sets
    render :action => 'play' if @game.active?
    render :action => 'archive' if @game.finished?
  end

  # Ajax refresh routine for auto-selection
  def refresh
    render_action = (play_cards ? 'setgame.xml' : 'setgame_unchanged.xml')
    @sets = @game.fill_gamefield_with_sets
    render :action => render_action
  end

  # the heart of the Setsolver game logic lies here.
  # This method handles new games, and all types of card submissions
  # (valid set, invalid set, wrong # of cards selected, etc. )
  def play_cards
    selection = get_card_numbers
    if (selection.length != 3)
      flash[:error] = 'You did not select three cards.'
      return false
    end
    selection_cards = selection.map {|i| @game.field[i] }
    @found_set = @game.make_set_selection( @player, *selection_cards )
    unless @found_set
      flash[:notice] = 'The three cards you selected are not a set.'
      return false
    end
    flash[:notice] = nil
    flash[:error] = nil
    true
  end

  # add player to current game
  def add_player
    add_remove_player :add
  end

  # add player to current game
  def remove_player
    add_remove_player :remove
  end

private

  # get Player, Game, and Score objects.  player and Game must be linked 
  # for this routine to run successfully.
  def get_player_and_game
    flash[:error] = nil
    @sets = []
    @player = Player.find(params[:player_id])
    if (params[:id])
      @game = Game.find(params[:id])
      @score = Score.find_by_player_id_and_game_id( params[:player_id], params[:id] )
      if @score.blank?
        flash[:error] = "Player ##{params[:player_id]} is not a member of this game."
        return false
      end
    end
    true
  end

  # get card numbers from params hash that takes the following form:
  # key = :card<number>, value = "SELECTED"
  # The array of card numbers is always in numerical order.
  def get_card_numbers
    cardparams = params.clone.delete_if do |k,v|
      (v.to_s != 'SELECTED') || (k.to_s !~ /^card[0-9]+$/)
    end
    nums = cardparams.map {|cardparam| cardparam.to_s.sub(/^card/,'').to_i }.sort
  end

  ADD_REMOVE_OPTS = { :add => 'add_player', :remove => 'remove_player' }

  # internal routine for adding and removing players
  def add_remove_player( opt )
    return false unless ADD_REMOVE_OPTS.include? opt

    if !(params[:player])
      flash[:notice] = "You did not select a player to #{opt.to_s}."
    elsif @game.started?
      flash[:notice] = "'You can only #{opt.to_s} players to a game before starting."
    else
      if params[:player].include? :id
        new_plyr = Player.find params[:player][:id]
        @game.send(ADD_REMOVE_OPTS[opt], new_plyr)
      else
        flash[:notice] = "You did not select a player to #{opt.to_s}."
      end
    end
    redirect_to(player_game_url)
  end

end
