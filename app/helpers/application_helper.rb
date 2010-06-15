# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # handles printing number as adjective followed by noun using
  # built-in Rails functions.
  def number_noun_desc( num, noun )
    return "1 #{noun.singularize}" if num == 1
    return "#{num} #{noun.pluralize}"
  end

  # returns Yes or No based on Boolean value of object passed in
  def format_yn( expr )
    return (expr) ? 'Yes' : 'No'
  end

  def formatted_date( date )
    date.strftime("%m/%d/%Y %I:%M:%S %p") if date
  end

  # alias of Player of current_user
  def current_player
    current_user.player
  end
  
  def default_game_name
    "#{current_player.name}'s #{(current_player.games.length + 1).ordinalize} game"
  end
  
  def print_example_cards
    card_messages = Cardface.example_cardfaces.map do |cardface|
      "#{extra_small_setcard_img(cardface)} has <strong>#{cardface.to_s}</strong>"
    end
    card_messages.join(', ')
  end

  # --- Facebooker mock helper functions ---

  def mock_fb_profile_pic( user = current_user )
    "<img class=\"FB_profile_pic fb_profile_pic_rendered FB_ElementReady\"" + 
    " title=\"#{user.name}\" alt=\"#{user.name}\" src=\"#{user.pic_small}\">"
  end

  FbNameMockableOptions = [:possessive, :useyou, :capitalize]

  def mock_fb_raw_name( user, opts = {} )
    options = FbNameMockableOptions.inject({}) {|h, opt| h[opt] = opts[opt] || false; h }
    if options[:useyou] && (user == current_user)
      val = options[:possessive] ? 'your' : 'you'
      return options[:capitalize] ? val.titlecase : val
    end
    return user.name + ("'s" if options[:possessive]).to_s
  end

  def mock_fb_name( user, opts = {} )
    "<a href=\"#{mock_fb_profile_url(user)}\" class=\"FB_Link\">#{mock_fb_raw_name(user,opts)}</a>"
  end

  def mock_fb_profile_url( user )
    "http://www.facebook.com/profile.php?id=#{user.facebook_id}"
  end

  def mock_fb_tabs(selected)
    tag = %q{<div class="fb-tabs clearfix"><div class="left_tabs"><ul class="fb-tabitems clearfix">}
    Game::GameTabs.each do |tab_name|
      tag_url = Game::GameTabMethods[tab_name]
      tab_vis_method = Game::GameTabVisibleConditions[tab_name]
      next if tab_vis_method && @player && !(@player.send(tab_vis_method))
      tag_selected_class = ((tab_name == selected) ? 'selected' : 'none')
      tag += "<li>#{link_to(tab_name.id2name.titlecase, tag_url, :class => tag_selected_class)}</li>"
    end
    tag += %q{</ul></div></div>}
  end
  
end
