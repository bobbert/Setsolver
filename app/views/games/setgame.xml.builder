xml.instruct!
xml.setgame do
  xml.field_size       @game.field.length
  xml.remaining        number_noun_desc(@game.deck.facedown.length,'card')
  xml.status           @game.status
  if flash[:notice]
    xml.notice         flash[:notice]
  end
  if flash[:error]
    xml.error          flash[:error]
  end
  xml.num_sets       number_noun_desc(@sets.length, 'set')
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