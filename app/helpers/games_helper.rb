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

end
