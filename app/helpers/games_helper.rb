module GamesHelper

  # renders wait text for when user submits three-card set.
  def wait_text
    str = 'Waiting for results... ' + image_tag('spinner.gif', :alt => 'spinner')
  end

  # prints three card set as miniature cards
  def render_threecard_set( tcs )
    return render_dummy_set if tcs.blank?
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
  def game_desc_as_link( gm )
    link_to(gm.listing, game_path(gm))
  end

  # create game number as link
  def game_play_link( gm )
    if gm.active?
      link_to("Play game", play_path(gm))
    elsif gm.finished?
      link_to("View game archive", archive_path(gm))
    else
      'Game not yet started.'
    end
  end

  # returns image HTML for a single card
  def card_image( card )
    image_tag(('cards/' + card.img_name), :height => 90, :width => 60, :alt => card.to_s)
  end

  def render_set_found_text( set )
    "<h5>#{formatted_date(set.created_at) if set}</h5> " + 
    "<span class=\"setlisting-name\">#{set.score.player.name if set}</span> found " + 
    "<p class=\"setlisting\">#{render_threecard_set(set) if set}</p> " + 
    "in <span class=\"setlisting-time\">#{set.seconds_to_find if set}</span> seconds"
  end

end