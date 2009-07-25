# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # handles printing number as adjective followed by noun using
  # built-in Rails functions.
  def number_noun_desc( num, noun )
    return "1 #{noun.singularize}" if num == 1
    return "#{num} #{noun.pluralize}"
  end

end
