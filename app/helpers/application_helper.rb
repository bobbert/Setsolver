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

end
