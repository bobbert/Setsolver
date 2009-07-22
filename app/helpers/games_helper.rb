module GamesHelper

  # prints three card set as miniature cards
  def render_threecard_set( cards )
    str = ' '
    cards.each do |c|
      str += image_tag( ('cards/' + c.img_name),
                        :height => '90', :width => '60', :alt => c.to_s ) + ' '
    end
    str
  end

  # renders Set board as HTML
  def render_board( gameid )
    gm = Game.find gameid
    return "<table></table>" unless gm

    tbl_html = "<table border=0 width=#{Game::BOARD_TABLE_WIDTH} id=\"setboard\"><tr height=#{Game::BOARD_CELL_HEIGHT}>"
    gm.cards.each_with_index do |c,i|
      tbl_html += '</tr><tr>' if ((i % Game::VIEW_COLS == 0) && (i > 0))
      tbl_html += "<td align=center valign=center id=cell#{i.to_s} class=\"unselected\"
  width=#{Game::BOARD_CELL_WIDTH} height=#{Game::BOARD_CELL_HEIGHT}>" +
  hidden_field_tag(('card' + i.to_s), i) + image_tag(('cards/' + c.img_name), :alt => c.to_s,
   :onclick => "javascript:toggle_chk(#{i.to_s});") + '</td>'
    end
    return tbl_html + '</tr></table>'
  end

end