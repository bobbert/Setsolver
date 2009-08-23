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
    @player = Player.find(params[:player_id])
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
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
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end


end
