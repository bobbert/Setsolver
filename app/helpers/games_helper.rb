module GamesHelper

  # renders wait text for when user submits three-card set.
  def wait_text
    str = 'Waiting for results... ' + image_tag('spinner.gif', :alt => 'spinner')
  end

  # prints three card set as miniature cards
  def render_threecard_set( s )
    str = ' '
    s.cards.each do |c|
      str += image_tag( ('cards/' + c.img_name),
                        :height => '90', :width => '60', :alt => c.to_s ) + ' '
    end
    str
  end

  # quick description of game
  def game_desc( gm )
    "[\##{gm.id}] \"#{gm.name}\""
  end

  # create game number as link
  def game_desc_as_link( plyr, gm )
    link_to(game_desc(gm), player_game_path(plyr,gm))
  end

  # create game number as link
  def game_play_link( plyr, gm )
    if gm.active?
      link_to("Play game", play_path(plyr,gm))
    elsif gm.finished?
      ' Game Finished'  # temporary -- need archiving page
    else
      'Game not yet started.'
    end
  end

  # returns image HTML for a single card
  def card_image( card )
    image_tag(('cards/' + card.img_name), :alt => card.to_s)
  end

  
end