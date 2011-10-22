require 'uri'
require 'open-uri'
    
helpers do
  def valid_image_link(url)
    return false unless url =~ URI::regexp
    
    begin
      open(url) do |f|
        return false unless f.content_type =~ /image/
      end
    rescue OpenURI::HTTPError
      return false
    end
    url
  end
end
