module GamesHelper

  # renders wait text for when user submits three-card set.
  def wait_text
    str = 'Waiting for results... ' + image_tag('spinner.gif', :alt => 'spinner')
  end

  # prints three card set as miniature cards
  def render_threecard_set( tcs )
    tcs.cards.inject('') do |str,c|
      str += ' ' unless str.length == 0
      str += image_tag( ('smallcards/' + c.img_name), :height => 45, :width => 30, :alt => c.to_s )
    end
  end

  def render_dummy_set
    str = ""
    3.times do |x|
      str += ' ' unless str.length == 0
      str += image_tag( 'cards/card_template.png' )
    end
    str
  end

  # create game number as link
  def game_desc_as_link( plyr, gm )
    link_to(gm.listing, player_game_path(plyr,gm))
  end

  # create game number as link
  def game_play_link( plyr, gm )
    if gm.active?
      link_to("Play game", play_path(plyr,gm))
    elsif gm.finished?
      link_to("View game archive", archive_path(plyr,gm))
    else
      'Game not yet started.'
    end
  end

  # returns image HTML for a single card
  def card_image( card )
    image_tag(('cards/' + card.img_name), :height => 90, :width => 60, :alt => card.to_s)
  end

  
end