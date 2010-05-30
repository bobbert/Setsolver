class FinishedGamePublisher < Facebooker::Rails::Publisher

  def finished_game_template
    one_line_story_template "{*actor*} found {*selection_count*} sets in {*num_seconds*} seconds."
    short_story_template "{*actor*} has completed {*number_of_games*} Setsolver games!", "In the latest game, {*actor*} found {*selection_count*} sets in {*num_seconds*} seconds."
    action_links action_link('Can you beat this time?', 'http://apps.facebook.com/setsolver')
  end

  def finished_game(user)
    send_as :publish_stream
    from user.facebook_session.user
    target user.facebook_session.user
    a = Facebooker::Attachment.new
    a.name = user.wall_header_for_last_finished_game
    a.description = user.wall_post_for_last_finished_game
    attachment a
  end

end
