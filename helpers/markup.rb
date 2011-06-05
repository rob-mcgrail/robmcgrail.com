helpers do
  def title(str)
    "#{str} | robmcgrail.com"
  end

  def full_link_to(name, url, opts={})
    link_to(name, url_for(url, :full), opts)
  end

  def print_tags(object, opts={})
    str = ''
    if opts[:narrow]
      path = "/#{object.category}/tag/"
    else
      path = "/tag/"
    end
    object.tags.each do |tag|
      str << full_link_to("##{tag.name}", path + tag.name,:class => 'tag') + ', '
    end
    str.slice!(-2..-1)
    str
  end
end

