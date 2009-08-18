class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    # listing all players within selected game
    @players = @game.players

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
     @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        flash[:notice] = 'Player was successfully created.'
        format.html { redirect_to([@player.game, @player]) }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Player was successfully updated.'
        format.html { redirect_to([@player.game, @player]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end


#------ my controller methods ----#

  # the heart of the Setsolver game logic lies here.
  # This method handles new games, and all types of card submissions
  # (valid set, invalid set, wrong # of cards selected, etc. )
  def play
    @player = Player.find(params[:id])
    @game = Game.find(params[:game_id])
    # checking if initial page loading or user-submitted load
    if params[:commit]
      selection = get_card_numbers
      if selection.length != 3
        @caption = 'You did not select three cards.'
      else
	@found_set = @player.make_set_selection( *selection )
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