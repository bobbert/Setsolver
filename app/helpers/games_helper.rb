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

  # renders Set board as HTML
  def render_board( gm )
    return "<table></table>" unless gm

    tbl_html = "<table border=0 width=#{Game::BOARD_TABLE_WIDTH} id=\"setboard\"><tr height=#{Game::BOARD_CELL_HEIGHT}>"
    gm.field.each_with_index do |c,i|
      tbl_html += '</tr><tr>' if ((i % Game::VIEW_COLS == 0) && (i > 0))
      tbl_html += "<td align=center valign=center id=cell#{i.to_s} " + 
		  "width=#{Game::BOARD_CELL_WIDTH} height=#{Game::BOARD_CELL_HEIGHT}> " +
		  check_box_tag(('card' + i.to_s), 'SELECTED',false) + card_image(c) + '</td>'
    end
    return tbl_html + '</tr></table>'
  end

end