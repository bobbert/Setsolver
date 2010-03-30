xml.instruct!
xml.setgame do
  xml.field_size       @game.field.length
  xml.remaining        number_noun_desc(@game.deck.facedown.length,'card')
  xml.status           "unchanged"
  if flash[:notice]
    xml.notice         flash[:notice]
  end
  if flash[:error]
    xml.error          flash[:error]
  end
  if @sets.length > 0
    xml.num_sets       number_noun_desc(@sets.length, 'set')
  end
end
