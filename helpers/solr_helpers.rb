require 'rest_client'
require 'nokogiri'

module SolrHelpers

  def self.serialise_to_xml(o, h)
    record = Nokogiri::XML::Builder.new do |xml|
      xml.add(:allowDups => 'false') {
        xml.doc_ {
          h.each do |k,v|
            val = o.__send__(v.to_sym)
            # Horrible hack to cope with the insanity that is ruby 1.8.7's
            # DateTime class
            if val.class == DateTime
              val = val.to_s.gsub(val.zone, 'Z')
            end
            xml.field(val, {:name => k.to_s})
          end
        }
      }
    end
    record.to_xml
  end
  
  def self.solr_delete
    delete_reference = "<delete><id>#{o.id}</id></delete>"
    self.solr_update(delete_reference)
  end
  
  
  def self.solr_update(record, uri='http://0.0.0.0:8983/solr/update')
    RestClient.post uri, record, :content_type => 'text/xml; charset=utf-8'
  end
  
end

