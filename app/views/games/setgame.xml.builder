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
  if @sets.length > 0
    xml.num_sets       number_noun_desc(@sets.length, 'set')
  end
  xml.cards do
    @game.field.each_with_index do |card,i|
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
	xml.score       plyr.score(@game)
      end
    end
  end
end
