helpers do

  ##################
  # Markup helpers #
  ##################

  def title(str)
    "#{str} | robmcgrail.com"
  end

  def full_link_to(name, url)
    link_to(name, url_for(url, :full))
  end

  def print_tags(object)
    str = String.new
    object.tags.each do |tag|
      str << full_link_to(tag.name, "/tag/#{tag.name}") + ', '
    end
    str.slice!(-2..-1)
    str
  end

  ######################
  # Javascript helpers #
  ######################

  def show_hide(divid, linkid)
    str = "$(document).ready(function(){"
    str << "$('#{linkid}').click(function(){"
    str << "$(\"#{divid}\").fadeToggle('fast');});});"
  end
end

