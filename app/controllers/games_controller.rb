class GamesController < ApplicationController
  # GET /players/1/games
  # GET /players/1/games.xml
  def index
    # listing all games within selected player
    @player = Player.find(params[:player_id])
    @games = @player.games

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /players/1/games/1
  # GET /players/1/games/1.xml
  def show
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /players/1/games/new
  # GET /players/1/games/new.xml
  def new
    @player = Player.find(params[:player_id])
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /players/1/games/1/edit
  def edit
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])
  end

  # POST /players/1/games
  # POST /players/1/games.xml
  def create
    # get player and game, but do not check for Score "connector" object.
    @player = Player.find(params[:player_id])
    @game = Game.new(params[:game])

    respond_to do |format|
      # creating new game, and new association between selected player and game
      if @game.save && @game.new_player_score(@player)
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
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])

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
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])

    # delete Score first, then Game
    Score.find_by_player_id_and_game_id( params[:player_id], params[:id] ).destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end

#------ my controller methods ----#

  # the heart of the Setsolver game logic lies here.
  # This method handles new games, and all types of card submissions
  # (valid set, invalid set, wrong # of cards selected, etc. )
  def play
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])
    # checking if initial page loading or user-submitted load
    if params[:commit]
      selection = get_card_numbers
      if selection.length != 3
        @caption = 'You did not select three cards.'
      else
	@found_set = @player.make_set_selection( @game, *selection )
        @caption = 'The three cards you selected are not a set.' unless @found_set
      end
      @game.refresh_field unless @caption
      render :action => '_gamefield'
    else
      @game.refresh_field
      render :action => 'play'
    end
  end

  # get HTML table with all active set cards in the table cells
  def refresh
    @game = Game.find(params[:id])
    render :action => '_board'
  end

private

  # validates player and game ID, and assigns local attributes if true
  def validate_player_and_game
    # checking whether player is actively playing the game
    return false unless Score.find_by_player_id_and_game_id( params[:player_id], params[:id] )
    # assign player and game parameters if valid
    @player = Player.find(params[:player_id])
    @game = Game.find(params[:id])
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


end
