class PlayerController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
    @player_pages, @players = paginate :games, :per_page => 10
  end

  def create
    @game = Player.new(params[:game])
    if @game.save
      @caption = 'Player was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

#------ my controller methods ----#



end
