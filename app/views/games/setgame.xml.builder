xml.instruct!
xml.setgame do
  xml.field_size       @game.field.length
  xml.remaining        number_noun_desc(@game.deck.facedown.length,'card')
  xml.status           @game.status
  if flash[:notice]
    xml.notice         formatted_date(Time.now) + ': ' + flash[:notice]
  end
  if flash[:error]
    xml.error          formatted_date(Time.now) + ': ' + flash[:error]
  end
  xml.num_sets       number_noun_desc(@sets.length, 'set')
  if @game.active?
    xml.cards do
      @game.cards_by_node_order.each_with_index do |card,i|
        xml.card do 
          xml.id          card.id
          xml.field_id    i
          xml.name        card.to_s
          xml.image_path  card.img_path
        end
      end
    end
  end
  if @found_set
    xml.found_set do 
      xml.created_at       formatted_date(@found_set.created_at)
      xml.found_by         @found_set.player.name
      xml.setcards do
        @found_set.cards.each do |card|
          xml.setcard do
            xml.name        card.to_s
            xml.image_path  card.small_img_path
          end
        end
      end
    end
  end
  xml.gamestats do
    @game.players.each do |plyr|
      xml.player do
        xml.id          plyr.id
        xml.name        plyr.name
        xml.points      plyr.score(@game).points
      end
    end
  end
end
