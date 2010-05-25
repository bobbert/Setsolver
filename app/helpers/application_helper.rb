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

  # Facebooker mock helper functions
  def 
  
  
end
